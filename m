Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBB667A8BF
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbjAYC0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjAYC0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:26:51 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38920530FB
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 18:26:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIkq7zZveCRh5KrsAR7MJ7lAjiU417VVg0GZV+F4fAB93wNVx9Oc75CwzHoi/gdsks2IOYUmrv4S3VfKiViiizccBjoO35nzQl/BWv2SGMZRH0jciRWTwpGm9rlBdH1U3OZRJDJjzGZZQ/9QS5uQ+Y9mevp1PyWzPI3JkAd3LrNCSnck++tXMdG0+gDxUDWI9btzzJ/JNa4td65cqrbc1mGw19gMRuuSs+J4EG+eebxUMB3xA/UKpFvN3XdWt5gqMS9UsUKQr/H1FvIQzJF7o413HxCuUEeBErsMLov54koHUcG4XbBRKT5ZJPsPwNr1AW+3ExfYhHJiRt4wVENRaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M7CDWDeUyBU+VAqp8sYIgl9hFwLlcjZUzcEGaFfygiU=;
 b=PDRdiCvd9zRowKKDT1sKmKMG9ZuNVEhZ/XD/9kBUM+QMjjEJNtnE74SucL7x1bPZ7Yqt/pKvnaV3xbYHGsm3V2FrVgyPrm8G+ngyKfHKwLK+VFO8p7KlzEFtmT7hezrPmN/IbitL84MPfd9MBKcV1k6HuQxBGcjZ7LOgtyhWOsmTH8VU41mwqJSwLzbI5R5GSL/P9Ddwc2Efkz3xVgIK+5mIQmHPL2AI7KNPQmXsz1U1n9M8PDmZEPPWpijukePj0sTJmLGunPwwA5ydNecvRIrnsvrhd9Taibgr9PoOzjE8wRewBI9FmdTvfpwSnDd72H7ABLg/0yLjdZCish9YJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7CDWDeUyBU+VAqp8sYIgl9hFwLlcjZUzcEGaFfygiU=;
 b=DJlxep0DFinbsduAzhe0c7+XdQppZRzc9IRQ8ExVjlB1WKr88IzfmkbA6dE0KzA7ZT457D6M3xDdeno5TlS0iUsD2Ja/t3LbdcAYaBMVgjlnKoqG0Gwe87wE0d68gLOYf1KVp0Tdho08y0FYfwdv3Hu3Y02CZ0c0qq5Vd5qHlST8YZH5jBKT1SBur91VEMbMuNIKd018Jrv0GEj9GUKMO7mAQw/8h9ierpJms736fNPdF4FGT+/ycXpMm5btsZo1gmorPTGXo9M3l+DgEcms3310sCJe7hObpe4MfJiSE/e8aR4vQDaNgN1t+kmiuqiOPezC8sd1mY8gvIMahrbdsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM4PR12MB7742.namprd12.prod.outlook.com (2603:10b6:8:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 02:26:32 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 02:26:32 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Bar Shapira <bar.shapira.work@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
References: <87r0vpcch0.fsf@nvidia.com>
        <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
        <20230120160609.19160723@kernel.org> <87ilgyw9ya.fsf@nvidia.com>
        <Y83vgvTBnCYCzp49@hoboy.vegasvil.org> <878rhuj78u.fsf@nvidia.com>
        <Y8336MEkd6R/XU7x@hoboy.vegasvil.org> <87y1pt6qgc.fsf@nvidia.com>
        <Y88L6EPtgvW4tSA+@hoboy.vegasvil.org>
        <8fceff1b-180d-b089-8259-cd4caf46e7d2@gmail.com>
        <Y9AuU4zSQ0++RV7z@hoboy.vegasvil.org> <20230124164832.71674574@kernel.org>
Date:   Tue, 24 Jan 2023 18:26:20 -0800
Message-ID: <87tu0ftkmr.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::39) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM4PR12MB7742:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e1bb4a-37d4-4553-18fd-08dafe7b92a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CHAf055XfaP+1rzReTrczh5BFBYxWP/m1Z36dDePbV01+RrmnX4B5mtJjKBysGPgWTTOc0SQr9Wxi7AL/htkKYS8DF78WTFmXk0jQ+JYui8NMLZkYLe2JNxP6aarx0Q1IWSOpP5OYOHVzlm8YLraB2GsRta1tOO9kE0G3J2W5qnjRK6hR8YaDLpqdT/G4m/VksMyLvVwp39SVOeWmeymAEBPKUfsqNHa8vJoVkt//ZqKsvA9vU56CCcNSfCe0mfWVHaVGt3cdmpvporD1RWYH69r9lIvqRQcvP1ygQneQOaWqsA6BLmlFdSusg/VnCgcA4ALIg9DysrVtkRUckG9aQwmCNhutfBTbDzSVqnhwIQacwdSxlX1aGk4bzy7rYRBITrchmO4XpZkSvsPqnjLw2w1BbtHk+3Yydc1GSAKx8ZiV9jBSBIM8i7t19+Nr7a45g3f2zfOjn7j8USfZYgrAKz8paoHSh0xnggWy6cdH/QmsWwAF6rbxRcLb/VcnveEhjRKcNIfJvr5BTkUOuMfLTMEa48Ync1I9/xhU6OgWGWU2DX4f0qK7JR49SSPDDXfbUWepngudNHRROn0Jlq9P6Jn+gpRz9ezA9/Ls4tuQJ3KauA1zPvj9n6SnSGpTVGpWNFKm9ybkx8fY940Z2lPOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199018)(6486002)(316002)(86362001)(54906003)(186003)(6512007)(2906002)(2616005)(5660300002)(6916009)(38100700002)(66476007)(8936002)(8676002)(66556008)(7416002)(41300700001)(6666004)(66946007)(478600001)(36756003)(4326008)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pWDsvgzdwUTIlPgE/dNadMPCDhDpWdxbPWHyVHGgLVSk3d2bXFehflYMXkGu?=
 =?us-ascii?Q?8lTahSIkA0ALeHhom/ze+TpAaLzvhFUzblJfM0XNwRJzYVtqpI+y50/eWdP/?=
 =?us-ascii?Q?3ATY5njn0JlIAFN+g1X7r2I3WOcTr1M47oXXOW4UiAV6KXwYiIGm3QoOhutP?=
 =?us-ascii?Q?JnV1TZHc1kCAbXR9vw4Ex0uW9QpRSA0t5Ls4JjtTqco9OkmF7yC1weQ2+Zuw?=
 =?us-ascii?Q?L4C/HJ+xx60KxvutgaV19SC2GucwPUQhuqWGhxfJxDn/rf14VXrw16mngjTi?=
 =?us-ascii?Q?IL3jzJTTn2IqLICBYM0ZqCqIJnm6vZ2lF9H4KAbqUppGjF/7VAyq5xkZziD2?=
 =?us-ascii?Q?8GJLnwPRdH/ODXyJ/CDBssht5MLXFB0tOPox1xjGvwSKV4CUzbvUhnK1VfBM?=
 =?us-ascii?Q?yhwoHrVzuGaOTUTdt6scAeRXyMVHSVp9qxJRhI/nmYZ8eRR283SfoMOXO2S8?=
 =?us-ascii?Q?ODWvJ/YJi8lOsR7NGDtbmU+3TaJLnFxkjWLoTmN7f4k6+U29Wyy3+Zfds9WL?=
 =?us-ascii?Q?JtFMXEu0YStaMxWvMnNxbw2VywbFutO9iQWwvdTpvyaJ80rp6gvMmmuWHsUq?=
 =?us-ascii?Q?eTxIJhflAH8BDhFE/GupgMLQbSotZG5PcVFCWcVoS86rkCwBdNRMM9QdI9Ug?=
 =?us-ascii?Q?AuMwYthUVdeLo0NuuNV3e31+qhYH3ors4tgWSMXrKGkns9Wrs1kvkebVcRQ8?=
 =?us-ascii?Q?nKTqy+us4aeBBSCBMGxik/DQxCdG+TFTo9r8q2j6AYzQJz4L9Eb1bFBHbiS7?=
 =?us-ascii?Q?kCajfPj0qFbMhx9OJwQjl4gRzzevtR6MPhCzT39QNBHWSiSI3X49W2CGuZ7U?=
 =?us-ascii?Q?LXbh8bWUXGAY8Ds6G1rAnpYVCXkMAW385wcmLfidyMWcpQ1LcGR7triIrMW5?=
 =?us-ascii?Q?gS2X/U+UPvY/ZBpPZ52nFAlrElu6UGhDN00LwXEexfj1MQLW2AD0PXy/bzrU?=
 =?us-ascii?Q?OO6wjFxKbHqgGmLKD9d6ipqLT/ntonOEIgyae1vPRpqOwclZo8d4jnxxH9Kq?=
 =?us-ascii?Q?R+YvNi9Sp+qaR9MDO/+c2GCDyCcs5r0PF/5j/BtDB8ttgVS8jiYFzQl5/WZ6?=
 =?us-ascii?Q?EZG/2oSpMS6KlyGfISPi8CNxBPT6RG+czMbrwILdvdjCYdwxMEoiF6n2PfGY?=
 =?us-ascii?Q?GIVak+3UpZdYmiI104k+lPnKH0OiQhWzS2nZYIttNrTbJahJkw9Gr/pCgLDp?=
 =?us-ascii?Q?lt0lY61eaOY7pzrNiSIVtWcXH8ng7zt7VtFWpLILqw4SmLcb/4tw8ukt2pda?=
 =?us-ascii?Q?jBXzu4a0ofmaGLSRzA223ambgsdVNaTSLb414W67Kh7+WUTbyzKLbnr5T6Ry?=
 =?us-ascii?Q?qxoK3Rm7NPIBdEqhpZWcQW0eBWTi6n8sv77hu3jovaS4zsqpIlJduqq9zrBq?=
 =?us-ascii?Q?S/ShMozF0wyyB34RqUtqGoLUD8gwOmNbkU5sWuZGStD9fSTsoMEmFXTGzPUm?=
 =?us-ascii?Q?aAiiLiLct2WwGTEqg/iIUMOzpyi9kw4Sizd9KZQ6mSjWdWq7ItXvKFIoF84U?=
 =?us-ascii?Q?99kiVbdLmKbBlKg7CusTr4Co93TMKQLj4bNXl1LUQ7sgbUPg5M+9xh2t0XC1?=
 =?us-ascii?Q?6zE+8O2p6/iVaovcptL8l2QPm5U557YPR53cMugLjFjQgwX6r6LDv7CKFnic?=
 =?us-ascii?Q?Tto2ZSLVx31FiFEQ+rDTCS9fc3qYC69r11lY/zA9QBv1xG5OQVnP6Yj0KwVv?=
 =?us-ascii?Q?f9s8uQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e1bb4a-37d4-4553-18fd-08dafe7b92a8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 02:26:32.3612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vex+tSgcJ2F4iVP0Cj0Duwn7xgIEcoVpoh3rBOQcDKB/9EL/enm5vsutjXRdguz4RjRaqmzpqamYltgOfBWIBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7742
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan, 2023 16:48:32 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 24 Jan 2023 11:15:31 -0800 Richard Cochran wrote:
>> On Tue, Jan 24, 2023 at 12:33:05PM +0200, Bar Shapira wrote:
>> > I guess this expectation should be part of the documentation too, right? Are
>> > there more expectations when calling adjphase?  
>> 
>> I'll gladly ack improvements to the documentation. I myself won't
>> spend time on that, because it will only get ignored, even when it is
>> super clear.  Like ptp_clock_register(), for example.
>
> IMHO it is a responsibility of maintainers to try to teach, even if not
> everyone turns out to be a diligent listener/reader. I've looked for
> information about this callback at least twice in the last 6 months.
>
> nVidia folks, could you please improve the doc, in that case? 

ACK. We have a patch series underway for this. Other aspects of the
patch series include adding adjphase support to the testptp kselftest
(currently missing) and advertising the max phase offset supported by a
driver.
