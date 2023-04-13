Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649056E08FD
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjDMIfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjDMIfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:35:07 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE167692;
        Thu, 13 Apr 2023 01:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk8cv9N5uNlyFdkxTJSV9DPN8FlhZqQrgRMk2ZsPnE8=;
 b=S+P8NiuIDn8fUND0ax+325ZIZym6YlQi+YTvoPG6XVw+05aHP+Q/lv/u4SgEihaejPcX93KdExjZhJuesj69lugCFSIGG5wa39MfoNoGVd7yw+C86EKMYH5iwQWpPfuoQLKuEKvabQGSvPIl9SpWRyu5J20O4kU30bBct7LHpvw=
Received: from AS9PR06CA0778.eurprd06.prod.outlook.com (2603:10a6:20b:484::32)
 by VE1PR08MB5631.eurprd08.prod.outlook.com (2603:10a6:800:1ab::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 08:35:00 +0000
Received: from AM7EUR03FT063.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:484:cafe::89) by AS9PR06CA0778.outlook.office365.com
 (2603:10a6:20b:484::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.31 via Frontend
 Transport; Thu, 13 Apr 2023 08:35:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT063.mail.protection.outlook.com (100.127.140.221) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.32 via Frontend Transport; Thu, 13 Apr 2023 08:35:00 +0000
Received: ("Tessian outbound 3a01b65b5aad:v136"); Thu, 13 Apr 2023 08:34:59 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d5e04a2226e6bcf0
X-CR-MTA-TID: 64aa7808
Received: from 12cf4ac8d256.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 07C34EA8-FD17-4FB1-AC41-CC9CCC89F3AC.1;
        Thu, 13 Apr 2023 08:34:52 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 12cf4ac8d256.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 13 Apr 2023 08:34:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9yHoKuB0ATi0+e+3W8Hsn6olmY6IJNYNv2FSN0Rh05dGkdDwxE4RVf3Cg/H22OOh344DqpLRGd94tGIvv3msbxux3497+OYwdQw/BDP0iCUX13tbYDJIrDlLn/B8hJ8TOw5+RLfH35aApLUiOnBGLwXH+jKKOP1US5m7YPDZl1OE9ESEbZ4itwdM+cYJ2YjjCq0sWYUDHYOX3s8twu7XhIsVx39u5KacvSpHZwKarZZJ+0+lIjXnqnXf8aj6u9X8j313pPnO2aZdeX3YsipirBF4m8G/sfS/Slp7PWc3X28vooVA3yxSo7V2RqnH5toZujqs9pqc/0vnhJZ94i1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fk8cv9N5uNlyFdkxTJSV9DPN8FlhZqQrgRMk2ZsPnE8=;
 b=cOKGRPHbz8l5sMrpRwLPdwPWuWbof+TPOQsAYjP2vPFLQKDfMTeCUpP3Hvg6r1RMc6wdekgNjnCtaQPqE/J/1m3wM+dH1QlT+icBhaElo9oNZ2UrNFmGKDrc/pqEb7rfE0N48kxnOt8KyqDcwK+weFZrGfIoZY0r7l2dQClG/qWNFBLLWZ9K/ezPGrIvAH3K/bfBOLzLHy2uqa5xvVG67uxqbaPIF5GpEvjmhf5+VJs3uCiFrpU8isqqL1h0pi7lmfNx1xwzzF0n2gLw79lF3p3vbK0mVfvsKG7WOFF7/xhARxKW5LBLLdCkVRSiGQtjlBD2ACDeWLyLPyimkHavPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk8cv9N5uNlyFdkxTJSV9DPN8FlhZqQrgRMk2ZsPnE8=;
 b=S+P8NiuIDn8fUND0ax+325ZIZym6YlQi+YTvoPG6XVw+05aHP+Q/lv/u4SgEihaejPcX93KdExjZhJuesj69lugCFSIGG5wa39MfoNoGVd7yw+C86EKMYH5iwQWpPfuoQLKuEKvabQGSvPIl9SpWRyu5J20O4kU30bBct7LHpvw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB6570.eurprd08.prod.outlook.com (2603:10a6:10:251::14)
 by AS8PR08MB10269.eurprd08.prod.outlook.com (2603:10a6:20b:63c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 08:34:50 +0000
Received: from DB9PR08MB6570.eurprd08.prod.outlook.com
 ([fe80::6ca0:c6b0:2e2:3ef3]) by DB9PR08MB6570.eurprd08.prod.outlook.com
 ([fe80::6ca0:c6b0:2e2:3ef3%7]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 08:34:50 +0000
Message-ID: <710ed5a2-1c3a-3fb1-c015-55ded320db30@arm.com>
Date:   Thu, 13 Apr 2023 10:34:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] net: Finish up ->msg_control{,_user} split
Content-Language: en-GB
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230411122625.3902339-1-kevin.brodsky@arm.com>
 <20230412152548.GA26786@lst.de>
From:   Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20230412152548.GA26786@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0218.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::7) To DB9PR08MB6570.eurprd08.prod.outlook.com
 (2603:10a6:10:251::14)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR08MB6570:EE_|AS8PR08MB10269:EE_|AM7EUR03FT063:EE_|VE1PR08MB5631:EE_
X-MS-Office365-Filtering-Correlation-Id: 99439678-d711-481c-84ac-08db3bf9f864
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 32TINHaNuzqah4vb+gRp1NQB1aOusdYf86+7gmEq3q5JHEa8Xk+3aY6fhTr8F3VubjyOlB/oVAMeyypxNbNCbVtc+oEnnFqR5jZBlYS61Sxvd8mNHceDpddVcKVHhGVJGA85cz/2Pd6QV2osTCoq8Z8GSZ6aL0nNwAXWvVp/CLS5WBRpxe165+tjecz6ktdzJSFKxr45Qf0KrrDxmLO2TVXAYjw+H84qyr5Lpp2rBxf2muquauaZ1uWsCxCmckFGAegww6pXZs6i7E1f04FYB3f2LiKljTxmzJv5gxRQRQZa1ULM0tkFiB3GzgjP+HG4fKQA+8gGIgrW5HJUD+KfPM1VtjM4D3JpKSJ0GcKcXZyCxjiLvFS/muUqeYo8Zqbv4u+BlZg1vYVoS5PTiR00WBLL9dm/JoWQmFdUxSPWY9HXxdfMSa0JciTrud1sAeLrQ53EqVSujXM6pCRrET3GPM6opUTMDXg/4tmffKjes9ZYzTY+J9vAe4lV03yOakpkjQDi7vpjM+gy5OibiJv1FS9vdAKm6DBR191Y4hLXLXZhMxRoyJX0E51FCgxV94INdhcWJaFh9RgEQ5huajfcHMJbsJ51Ve7BGLwOQyX1r7sZRrWctlsw4wqSqNz2+GwPi0pjqHH0WyVtL3a4+ZWGsQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB6570.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199021)(316002)(38100700002)(6916009)(4326008)(66556008)(66946007)(66476007)(2616005)(5660300002)(41300700001)(44832011)(31686004)(36756003)(86362001)(6486002)(31696002)(54906003)(6512007)(6506007)(26005)(186003)(53546011)(2906002)(83380400001)(8676002)(8936002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10269
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 705b33a1-ed18-4126-3c68-08db3bf9f278
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PrKSuQlhM/t5EF+CXTpe7NRB0qWmjqNlSa/Xme/wlgmUkj5ObP1vmEWfzRKF6r0tLIA9lmLTnpSgwmIQMVEqskrbK+u5BflhGv3rqPM2Qn7b392yyD3KxHMnKUHZOr2mTMDbg3c2dEJE+kQY9e5D3R4O9dMpDzkejv77XEqsT6j3IqTyvtI97hPp2ocgoATJcoNqj+z51AcGfuLSr+DRgrbi1lPcM0nxY2DKNvPtjoxLSTflQuuy3hxvMz5CAEgtl6Jk/KlkJQKTsUWwv9jt3P9i9KrapEmv2xzxb3PGS7XB55G4UHLfZIcxxGPoFF3n8xx+cQ15J395xm4LKVKWuyFQwAtS6MW810F/dhSFgIc12zvDIdmVbIol+itwEE5GUgufhxSGYU/g0uP0zwCNGe+iNkSdQTb6f5LkZRMLg7Y+MtLc3I5nXnBqph7SI+ebUW6Jh176sWuvWS72Q6VD9+/m9sUgltlUv/VVs0zFpP514FESX1DTOsdnoKvdEoin1T37JlZBS0tpEvzPdSbHgU2LXGKxVoE9CI8s81R4XVKRxPzrYQx39Me9jPVka8J8oqqKL0rB02ScFtb4joahEUi/SJGxsx6wUavfkn57rRiDaimbTS1W8o/ATkOshz8+EFmAY6IpQXGQjdmgUxWGDUAEd3OS5H9i0gYbfdL+8ZNtBNp5oEt3Um2pJpUMtOQwkfBSPBjv6eESE+tPa5VUf16Ipr+9MwVWFA4XvcdxVKA=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(46966006)(40470700004)(36840700001)(2616005)(47076005)(40480700001)(53546011)(6512007)(6506007)(26005)(31686004)(186003)(336012)(40460700003)(36860700001)(8936002)(5660300002)(6862004)(8676002)(2906002)(83380400001)(450100002)(4326008)(70586007)(86362001)(54906003)(70206006)(41300700001)(316002)(31696002)(82740400003)(478600001)(356005)(44832011)(81166007)(6486002)(36756003)(82310400005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 08:35:00.2508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99439678-d711-481c-84ac-08db3bf9f864
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5631
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/2023 17:25, Christoph Hellwig wrote:
> On Tue, Apr 11, 2023 at 01:26:25PM +0100, Kevin Brodsky wrote:
>> This patch is attempting to complete the split. Most issues are about
>> msg_control being used when in fact a user pointer is stored in the
>> union; msg_control_user is now used instead. An exception is made
>> for null checks, as it should be safe to use msg_control
>> unconditionally for that purpose.
> So all of the fixes looks good to me.
>
>> Additionally, a special situation in
>> cmsghdr_from_user_compat_to_kern() is addressed. There the input
>> struct msghdr holds a user pointer (msg_control_user), but a kernel
>> pointer is stored in msg_control when returning. msg_control_is_user
>> is now updated accordingly.
> But this is a small isolated real bugfix.  So I'd suggest to split
> this into a simple and easily backportable patch, and do the rest
> in another.
>
>> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
>> index 2917dd8d198c..ae818ff46224 100644
>> --- a/net/ipv6/ipv6_sockglue.c
>> +++ b/net/ipv6/ipv6_sockglue.c
>> @@ -716,6 +716,7 @@ int do_ipv6_setsockopt(struct sock *sk, int level, i=
nt optname,
>>                      goto done;
>>
>>              msg.msg_controllen =3D optlen;
>> +            msg.msg_control_is_user =3D false;
> And this is another one that has a real effect.

Thank you, both good points! Will split that up into a series of three
patches.

Kevin
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
