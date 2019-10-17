Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D904DB5B6
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441250AbfJQSSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:18:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8240 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438601AbfJQSSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:18:20 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9HI985F001774;
        Thu, 17 Oct 2019 11:18:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XETZdTJRu/kUWX4zAbJytmcTlVq6QJ9eHEvM4xYRnhM=;
 b=hYbVufe0H32rhid/4XQGU9RExYvjfKkeI8cEM07FPKlctoTW3N6kMHCcFNYOgWcauV4t
 WsMnNzgcdC6t/mglemxtVsa0yJ+jdB2MLkoN/8aukYiy63x/5DS8wuee68Jued33ynzB
 jH0WnFPTQyo1QuKqRIZXIneYV3uilqta0Ho= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vpufxrnrm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Oct 2019 11:18:17 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 17 Oct 2019 11:18:15 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Oct 2019 11:18:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOZdthJTlJW3wRWDAApxHLIlTNDd7AHgdtJZPQHdY7Uw07jkawIRzFy+1h+HcOXX1xg0sTMiAr+eSQ14/Zr/83X/m9Q1JgviU1AvaRjEgrqWRuMdMfvCf+/IrrmOswy57zDtyH5Jzl+JFpMTI5KJsGgDoik9PIH72F1C92Fz2VQCbBPZcwcoOAOTZt41yFiaprrHcMam1AXtsumo7ZcpQDO+GEy+0yDNWZu+N6WyeYlvzedEbQV6+gCEV5kG3EpCRxXlxfK4cAdNBAGilX2bSPuDf0NXS+lJ4llKqQE/wgy43WHt7HtuVXx6wIjBNNGW3NydWj2yk02esiEITy1XCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XETZdTJRu/kUWX4zAbJytmcTlVq6QJ9eHEvM4xYRnhM=;
 b=muf0eW3eNFHRAvuy4f37pJiTl/QCphS575kcs5EG3S9y5VU62yvMeGhL+WrNAby30yORn50mA725dfeTXEAu40hvkatveH5x1jM2km7m0+reFkaO/4WaPYrMJxKJdx3oRs4wNzIV3qVO6m9VE+mLMt2q3j9Ix79oxSb/mIXWkbs0TQKVFFfHUgTV4znGe+QLa6duqD5hc/z4FhVUz2TvyTHWulTxGfNB+3GkmGAjQitfECnKUyPKlTnnZAaZbCiZhsRrivZWTQS/+fqGGb5P41wozIQYr8eaoyiyY3QEoWkP9H5997rHu3bJM1zsXBQG6gG1vjP/OhClUlAB7I0h9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XETZdTJRu/kUWX4zAbJytmcTlVq6QJ9eHEvM4xYRnhM=;
 b=BVe0bm282XbHLXxo7Lpokq0LwPW6fug6AY5vs3qtH/K6LG5InuZBAvNu6su1Igd2JuFczRhXAktjtaNKS5Ve+yzkJTdb4180+QI5DDM87eFEpQ+1i8Jl90kmn5ouyh8foQqUTKFrEY2b/6bczjO6UcTAD8UoLBQDtOih0RDRZs4=
Received: from DM6PR15MB3210.namprd15.prod.outlook.com (20.179.48.219) by
 DM6PR15MB3388.namprd15.prod.outlook.com (20.179.51.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 17 Oct 2019 18:18:15 +0000
Received: from DM6PR15MB3210.namprd15.prod.outlook.com
 ([fe80::cc98:c18d:1e80:b856]) by DM6PR15MB3210.namprd15.prod.outlook.com
 ([fe80::cc98:c18d:1e80:b856%7]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 18:18:15 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Andrii Nakryiko" <andriin@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Restore the netns after flow
 dissector reattach test
Thread-Topic: [PATCH bpf-next] selftests/bpf: Restore the netns after flow
 dissector reattach test
Thread-Index: AQHVhMYvudgTyJQPgUKf3mGwDuBjoadfJOwA
Date:   Thu, 17 Oct 2019 18:18:14 +0000
Message-ID: <20191017181812.eb23epbwnp3fo5sg@kafai-mbp.dhcp.thefacebook.com>
References: <20191017083752.30999-1-jakub@cloudflare.com>
In-Reply-To: <20191017083752.30999-1-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:301:2::28) To DM6PR15MB3210.namprd15.prod.outlook.com
 (2603:10b6:5:163::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ee07]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26b52bde-380f-4608-c3c3-08d7532e6076
x-ms-traffictypediagnostic: DM6PR15MB3388:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB338823A8316D1E6F640055B1D56D0@DM6PR15MB3388.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(136003)(346002)(39860400002)(199004)(189003)(66476007)(11346002)(66946007)(8936002)(478600001)(6486002)(6916009)(256004)(5024004)(14444005)(6512007)(2906002)(229853002)(476003)(4326008)(66446008)(9686003)(186003)(486006)(64756008)(46003)(66556008)(446003)(54906003)(386003)(6506007)(316002)(81156014)(25786009)(99286004)(71200400001)(6436002)(5660300002)(81166006)(8676002)(305945005)(6246003)(6116002)(71190400001)(76176011)(1076003)(52116002)(86362001)(7736002)(102836004)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3388;H:DM6PR15MB3210.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d/c3A5EPnIUFEZkJBWHVezVPgsa+ZaQEXTi/+TV1Oqq9xdzXdMpqzKROpT/3OWVnxQW8cvEsP/paGyFrIx4BJA8cYlyiMfXXtdf8M3qiABjYxrVvgev5MnfKepcCE++QiEvc5MU+8n+RoKx8ZNocbHE9b73AedXdpR8XAgn11TEsJm66KsOQW1SfUmj7s4kt6ckA9EbwFpunsKaomR1ap+hNkEaOIx1F6uvKbNPPVvUijQm8eNyfUVKLyBAujw9FltFyRCeK3frlcBcsq3vCnQj3E9AkDROFUXSyL6mFDxuM1qDrNrlAZvUVfmXOTwtQvMtvZcqnOVwQh1O9X1RcwSKO3yAyaJdN5xU0W2qDx5+M4BzPNir8QIilFYbeXUkONaZRCkSfz/xLyVaNqLrc/sgq5E+ms31tZontRkMfNww=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F1F3DD27FF8F2D478C430ECA4DD14081@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b52bde-380f-4608-c3c3-08d7532e6076
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 18:18:15.0020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KSAdNCwdw/f7aEY/2R6vSD12HByXrgUi468Vcfz/HU3Wza1BmMS0P0SggosmXBFs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3388
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_05:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910170164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 10:37:52AM +0200, Jakub Sitnicki wrote:
> flow_dissector_reattach test changes the netns we run in but does not
> restore it to the one we started in when finished. This interferes with
> tests that run after it. Fix it by restoring the netns when done.
>=20
> Fixes: f97eea1756f3 ("selftests/bpf: Check that flow dissector can be re-=
attached")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../bpf/prog_tests/flow_dissector_reattach.c  | 21 +++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reatta=
ch.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> index 777faffc4639..1f51ba66b98b 100644
> --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> @@ -91,12 +91,18 @@ static void do_flow_dissector_reattach(void)
> =20
>  void test_flow_dissector_reattach(void)
>  {
> -	int init_net, err;
> +	int init_net, self_net, err;
> +
> +	self_net =3D open("/proc/self/ns/net", O_RDONLY);
> +	if (CHECK_FAIL(self_net < 0)) {
> +		perror("open(/proc/self/ns/net");
> +		return;
> +	}
> =20
>  	init_net =3D open("/proc/1/ns/net", O_RDONLY);
>  	if (CHECK_FAIL(init_net < 0)) {
>  		perror("open(/proc/1/ns/net)");
> -		return;
> +		goto out_close;
Mostly nit.  close(-1) is ok-ish...  The same goes for the "out_close" in
do_flow_dissector_reattach().

Acked-by: Martin KaFai Lau <kafai@fb.com>

>  	}
> =20
>  	err =3D setns(init_net, CLONE_NEWNET);
> @@ -108,7 +114,7 @@ void test_flow_dissector_reattach(void)
>  	if (is_attached(init_net)) {
>  		test__skip();
>  		printf("Can't test with flow dissector attached to init_net\n");
> -		return;
> +		goto out_setns;
>  	}
> =20
>  	/* First run tests in root network namespace */
> @@ -118,10 +124,17 @@ void test_flow_dissector_reattach(void)
>  	err =3D unshare(CLONE_NEWNET);
>  	if (CHECK_FAIL(err)) {
>  		perror("unshare(CLONE_NEWNET)");
> -		goto out_close;
> +		goto out_setns;
>  	}
>  	do_flow_dissector_reattach();
> =20
> +out_setns:
> +	/* Move back to netns we started in. */
> +	err =3D setns(self_net, CLONE_NEWNET);
> +	if (CHECK_FAIL(err))
> +		perror("setns(/proc/self/ns/net)");
> +
>  out_close:
>  	close(init_net);
> +	close(self_net);
>  }
> --=20
> 2.20.1
>=20
