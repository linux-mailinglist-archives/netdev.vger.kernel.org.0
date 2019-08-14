Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 685E98E149
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 01:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfHNXfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 19:35:07 -0400
Received: from mail-eopbgr680093.outbound.protection.outlook.com ([40.107.68.93]:9607
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728370AbfHNXfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 19:35:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jk4NXvyk+9uFwd5YqH+xAmlndETwt5ieVVTOivhu+AUo/VPGycB7nmvAwM8kW8XoJvwDXkYY8RYULTARfz4ce6v+P2p9EDOsUk4SeVsznF6s+fEJf2Hwzoy9M1kh9B6lNY5CnGRwZGCyY0V9WX13vBtOs4VQX2hKj7LVcL5NGWriXo3IhPc1OVlXcDBr6BUYOV84b3vjnpNb2qR+SpzHlaRtu1RB5QGO5agRxMuWFknBQzPdhujUmILwewjEDfLA14H2Eb4zkTCN8d84hOiy5JqOuw2HhNEYEbJlH07KUOWWYHAqgsUWlWT7xGXhevJvrpQ/o/yCkgFOe3Mej39hLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ei2NFcOpGtqljrDaJt0OO380rgYpQcVwC9XcHbw3+bw=;
 b=S1KMUcrOzrCNDRVsRJSvcPtPwP9wP6Pu9PgqFn93GullWOI7mYSmC53Rc1YfdLZu0kbqMbP+uzi09PGz26JaWw5dfNqgnn8v5AxscZk7662cBUH2McSYMpwG29CGpPX31pPE3EisGQcEm2n4MTx9uXm3dCsSj2wvFW7DDswUTW8LR21Mkr8FxDViLwjKyT6Nbg3tHFnH2x6ic1PBeUk7tpsisrNhRwkxbDiqbSfJz9clh9nWR7H3IRBopQ7aJbPEtBMLm9tIvKdOkbSeFpOOzXTSkx5bTSrNeKtGYUWPmrlH9sk3+tRMQk5X4Zssrvo/XvOG4YHRAcwPj35cXwy28A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 160.33.194.228) smtp.rcpttodomain=linaro.org smtp.mailfrom=sony.com;
 dmarc=bestguesspass action=none header.from=sony.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector2-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ei2NFcOpGtqljrDaJt0OO380rgYpQcVwC9XcHbw3+bw=;
 b=J2CDkJc1ImAEJLt6oNw2K23Gy/fkOdH1lU2Qdcb+TY6tcYCP0vRbdnUVzl5DH8jRnd81GshI0rn1tytMKjMDEm6hDRuzNigP/Ou3tfgyEl+s65JUGe5HYKG96yIIA8+xD/PQ9fDG6yNY78L/MUCuvZlV4+v4t3VsW/6QD8NkYIk=
Received: from CY4PR13CA0082.namprd13.prod.outlook.com (2603:10b6:903:152::20)
 by BN6PR13MB1425.namprd13.prod.outlook.com (2603:10b6:404:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.13; Wed, 14 Aug
 2019 23:35:00 +0000
Received: from CY1NAM02FT025.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by CY4PR13CA0082.outlook.office365.com
 (2603:10b6:903:152::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2199.6 via Frontend
 Transport; Wed, 14 Aug 2019 23:34:59 +0000
Authentication-Results: spf=pass (sender IP is 160.33.194.228)
 smtp.mailfrom=sony.com; linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=bestguesspass action=none
 header.from=sony.com;
Received-SPF: Pass (protection.outlook.com: domain of sony.com designates
 160.33.194.228 as permitted sender) receiver=protection.outlook.com;
 client-ip=160.33.194.228; helo=usculsndmail01v.am.sony.com;
Received: from usculsndmail01v.am.sony.com (160.33.194.228) by
 CY1NAM02FT025.mail.protection.outlook.com (10.152.75.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2178.16 via Frontend Transport; Wed, 14 Aug 2019 23:34:59 +0000
Received: from usculsndmail14v.am.sony.com (usculsndmail14v.am.sony.com [146.215.230.105])
        by usculsndmail01v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id x7ENYwim005831;
        Wed, 14 Aug 2019 23:34:58 GMT
Received: from USCULXHUB06V.am.sony.com (usculxhub06v.am.sony.com [146.215.231.44])
        by usculsndmail14v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id x7ENYvge010838;
        Wed, 14 Aug 2019 23:34:57 GMT
Received: from USCULXMSG01.am.sony.com ([fe80::b09d:6cb6:665e:d1b5]) by
 USCULXHUB06V.am.sony.com ([146.215.231.44]) with mapi id 14.03.0439.000; Wed,
 14 Aug 2019 19:34:57 -0400
From:   <Tim.Bird@sony.com>
To:     <anders.roxell@linaro.org>, <davem@davemloft.net>,
        <shuah@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] selftests: net: tcp_fastopen_backup_key.sh: fix
 shellcheck issue
Thread-Topic: [PATCH] selftests: net: tcp_fastopen_backup_key.sh: fix
 shellcheck issue
Thread-Index: AQHVUupYcm8KhbZuh0SIGrwn5rxmsKb7SY0Q
Date:   Wed, 14 Aug 2019 23:34:54 +0000
Message-ID: <ECADFF3FD767C149AD96A924E7EA6EAF977A2939@USCULXMSG01.am.sony.com>
References: <20190814214948.5571-1-anders.roxell@linaro.org>
In-Reply-To: <20190814214948.5571-1-anders.roxell@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [146.215.231.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:160.33.194.228;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(396003)(376002)(2980300002)(13464003)(189003)(199004)(6116002)(2201001)(3846002)(246002)(8936002)(50466002)(8746002)(7696005)(55846006)(86362001)(110136005)(2906002)(76176011)(8676002)(316002)(23726003)(2876002)(229853002)(4326008)(70586007)(70206006)(55016002)(6246003)(478600001)(336012)(5660300002)(102836004)(186003)(26005)(46406003)(486006)(54906003)(426003)(126002)(446003)(476003)(33656002)(47776003)(97756001)(11346002)(356004)(14444005)(6666004)(7736002)(305945005)(37786003)(106002)(66066001)(5001870100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR13MB1425;H:usculsndmail01v.am.sony.com;FPR:;SPF:Pass;LANG:en;PTR:mail.sonyusa.com,mail01.sonyusa.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf735421-9bf3-4002-0afe-08d7211005cd
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN6PR13MB1425;
X-MS-TrafficTypeDiagnostic: BN6PR13MB1425:
X-Microsoft-Antispam-PRVS: <BN6PR13MB1425C2FB125CEB0DC32F6BE7FDAD0@BN6PR13MB1425.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 01294F875B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: zUQQKXLzFlfEFk8jARByTq9Ddchlta2iD2qJf0PFlfEjacHsWCGfRyQ/HfaCS164Y3N/2A05EmBNYmBtbQdd5vxe3hGC3V9SrRwJlNKi8FfAKlXcWLdZkP6s+qn4k46rUUqEwB8qJCtD5Rn/UlsXlDINnPTFqC9ZEpyr3sVZpf41NpEsOCoAt+q8BPn5vWFXX2w4NlXc9uQKrgRL/X/JTO3d1/+npIkUYeC6LUBKMLoZkFlA0DclaPxYuNwJKfXEwlpsSPPkIjm0u5eYtN9ha7JoyGcTX+QkAlQXQgLUxjepHMtKj7QEwSB8A0bccbreEMOXqvY1ulWYvrcA97UGX4IJPvcgRl4V3yHfsLbPZi5qUKgHlgun0bzjDpamul4JWC1OtWTtrixyU8z+Htm1M6G6vPhw1fNL/I3KVqewMLc=
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2019 23:34:59.2379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf735421-9bf3-4002-0afe-08d7211005cd
X-MS-Exchange-CrossTenant-Id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=66c65d8a-9158-4521-a2d8-664963db48e4;Ip=[160.33.194.228];Helo=[usculsndmail01v.am.sony.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1425
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Anders Roxell
>=20
> When running tcp_fastopen_backup_key.sh the following issue was seen in
> a busybox environment.
> ./tcp_fastopen_backup_key.sh: line 33: [: -ne: unary operator expected
>=20
> Shellcheck showed the following issue.
> $ shellcheck tools/testing/selftests/net/tcp_fastopen_backup_key.sh
>=20
> In tools/testing/selftests/net/tcp_fastopen_backup_key.sh line 33:
>         if [ $val -ne 0 ]; then
>              ^-- SC2086: Double quote to prevent globbing and word splitt=
ing.
>=20
> Rework to add double quotes around the variable 'val' that shellcheck
> recommends.
>=20
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  tools/testing/selftests/net/tcp_fastopen_backup_key.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/net/tcp_fastopen_backup_key.sh
> b/tools/testing/selftests/net/tcp_fastopen_backup_key.sh
> index 41476399e184..ba5ec3eb314e 100755
> --- a/tools/testing/selftests/net/tcp_fastopen_backup_key.sh
> +++ b/tools/testing/selftests/net/tcp_fastopen_backup_key.sh
> @@ -30,7 +30,7 @@ do_test() {
>  	ip netns exec "${NETNS}" ./tcp_fastopen_backup_key "$1"
>  	val=3D$(ip netns exec "${NETNS}" nstat -az | \
>  		grep TcpExtTCPFastOpenPassiveFail | awk '{print $2}')
> -	if [ $val -ne 0 ]; then
> +	if [ "$val" -ne 0 ]; then

Did you test this in the failing environment?

With a busybox shell, I get:
 $ [ "" -ne 0 ]
sh: bad number

You might need to explicitly check for empty string here, or switch to a st=
ring comparison instead:
if [ "$val" !=3D 0 ]; then

   -- Tim

>  		echo "FAIL: TcpExtTCPFastOpenPassiveFail non-zero"
>  		return 1
>  	fi
> --
> 2.20.1

