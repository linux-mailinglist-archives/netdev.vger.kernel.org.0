Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5EE4B10A8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243063AbiBJOlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:41:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243040AbiBJOlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:41:49 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2083.outbound.protection.outlook.com [40.107.100.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A376BCD;
        Thu, 10 Feb 2022 06:41:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zw4K5cQgK/beKx1D/5WuljmibhekXpap1IWgeF7FFPFDEYzJn3a+Gt1YYlNCc4IbiM5Br2l7kMqi67zxHGdsHkqiK+6atXm9U8GjqR5utGFX+F2sn4AnXk6omqdGuLbceAgQ+wOaSwXlU4MvKRHlwRmtPlgmAOOy2A16KWXyiRBjqxUUgkh48b/Mi+m6KLms2JMNv6bYR31V6dv81TEGBVTmSJtVb/I0EBzEqHg2TW/vub8b5pFrJSoV2X6tv/eJJYA2pUhNyA6NLrADqhss8lXhVa1meHUBJVGZtvHu5QDLgZkVu1yp32ysxiO7evPbVeZwDNCYznBmwRnMp7ZSRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBaI0AAx/5fMS4gWN8xW4JUhnq2wTx4Naz1I512Rtsw=;
 b=YJQUDDfN+LFzAGgqz7oANHTAU7VxqiRlRh5miIaDg29lp8tf3N909PckGA5VJ58FDbsb3dkRe0/XIgZY/6xir+f7tmgsVBjRiY4uljBLq4mD5ZuQPpY+SRmYM3TT1xHZMoh4fqZvv1CY8cHCw+FUwECuGZCxCSLKWsblQlL0AUZ/RsBsd71gy+5gi7ubGH+0csUCLwGRQD3psTn8zCCSBw+H4vyPyNfSjgkAejILVTgPHMMwvVQnijHC0iDbD81S4IbrjUmtaZvJwYdf8qKr2SdIMrUJN1QJnQNd9eW4LGaR675H3MqypVxgImPy2EM3o3xI5/wTogwBa2d94rsh1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBaI0AAx/5fMS4gWN8xW4JUhnq2wTx4Naz1I512Rtsw=;
 b=PCC1ryUldt/NvlB4XXyQuo9jqtO5+u6R329u5Puqc9rRAlELaF2DiyVRBGFMZWQAoHjrZK7g7EcmFCbEBGheImUU6lS277DNSZjOQMdnddQanDV1/QQl6ql8ADhjuxgbxY4lUJApzOoeasK3/pRt2QIGfuE9rXmVTU9UMtTLkds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by SN6PR11MB3167.namprd11.prod.outlook.com (2603:10b6:805:c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 14:41:48 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4975.014; Thu, 10 Feb 2022
 14:41:48 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 05/24] wfx: add main.c/main.h
Date:   Thu, 10 Feb 2022 15:41:39 +0100
Message-ID: <4055223.VTxhiZFAix@pc-42>
Organization: Silicon Labs
In-Reply-To: <87r18a3irb.fsf@kernel.org>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <2898137.rlL8Y2EFai@pc-42> <87r18a3irb.fsf@kernel.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR0P264CA0123.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::15) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4471b21-962e-4c5c-aa8d-08d9eca37793
X-MS-TrafficTypeDiagnostic: SN6PR11MB3167:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB3167804D9FB92EC62331FF25932F9@SN6PR11MB3167.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1SfhuqgtfgjGMIBaWMXxXdmEMkJnhmRIsrz4wjIiPeT3mrTFMq/klgGwmJ9WL/9JcRKlRYFTaeMjtN2gCEVgnujRu6d5CoVa8cwQJIf4AWMHFQkp365jD1PwQ4yfN/2Lucq0YdREq6d2My/I6KO4/dDkotWnANN501zmQ9c9fOBSfZtjvIDtYaLMrK9HHU1nsPJBFYqr8PrYXqS8tHxzMI6p7BMoBN2oqegznAtc6YFVDWgq3swSgLVUJWAhuIsNHVz3QptxD7eGDheoOacCGRhrmPDGQSfEdUNQHN9ajhZ/U5intw7+UfJponRTwYXFPfVkjFjc6aybcpec6oPwLsvI9BorM5asidROjyGEelGlixxFEIAm9g1nweq08hxakZ54k+ZrX0zY9F6aYTzOB0WSmJrYN8884W/j3LgWnAQdADXJ0owZ+30qAr8oVKwE7WnYhjjHmmTtIBtSc3ZCi2mtf1yInJ1HuHyavE7WKDBHbw/1ZQ5UdlHQIIdqqikuujQAaekBgH1dAkQB4geYy4OhzbtZsKF+nODUJh3x8LHYIJP1jiFwDA1bA2vJ0MzAIXm2pu2R2CNco5HG4myJzK03NmKFx68E1ZVKjI4uOf0OOJzHDhENammBjIwouAGhIiRdeR6PCKlDa5ov5aBaS2FwvPV9zPFHm+m3AvjJdyJCPrUuw3vx6Hkuads9pBVuDsNhyiFh1S5BIHkxKuv2IaF56t/B+p6rVgnc+shClzichu1jtURSJ2q44gMrarlP+mnC3JrjR8K98MGxN2jvCCgNZOQUcd88e0zO5UFrTQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(33716001)(66556008)(26005)(38100700002)(66574015)(66476007)(316002)(186003)(8676002)(6512007)(38350700002)(9686003)(8936002)(4326008)(52116002)(6506007)(508600001)(6666004)(2906002)(7416002)(54906003)(36916002)(84970400001)(6486002)(5660300002)(6916009)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?5FgQyJ+2zUadajL7be1kwaFhBV+0RuXRNJSEACtz4mWQztTt6z8AskBgQV?=
 =?iso-8859-1?Q?C28nTp0F/pXtLA9WWORmkFmgKJ8ykSdn6VtWYxBnlxqlPmIoHxUXY5DmPz?=
 =?iso-8859-1?Q?qwId2kD3BrzvYSavaR0OjOT+MPK3Jt5J/7s7Xe9FIG+xX7VQvyJjKUwwcw?=
 =?iso-8859-1?Q?iM21MRL3eWlv0kJPkAvojX76TfyH5aCZUVoWxCwxees3BD+QrmFVWZ0E0a?=
 =?iso-8859-1?Q?iFF5dSDZYwfjjDiAnkKD8cdg1fJMK1DS6SA6yeEUwU4LfBhh6nUNORGwXZ?=
 =?iso-8859-1?Q?JUhRespPiDRkfmDitYyj4mnI7cZYj/4VKyjYgvNkNHITpJitbMkjXKYkKx?=
 =?iso-8859-1?Q?qJJlR8tsGIKafpUT/3t/s8E2aVbN2MNF5k9Sk0NAA1koDLLRZJop8rbbxE?=
 =?iso-8859-1?Q?Zu9I1vgESZJKEfV99seE83P8t0OGncAgSTSCNsc6hkUGo8vhtTm4jwjyTp?=
 =?iso-8859-1?Q?Awauauo3HmhfbTD4lahG36fkFBewE6ExHk5gUwrxJRWHryMsZqw+OvxAKj?=
 =?iso-8859-1?Q?DGG0e8FPJB65K9iiUSJc+iXEvEbCgQ4vqZScdHtqq9DsZ6VPQmcLP3IOOp?=
 =?iso-8859-1?Q?rVQHk1KGTAbgTKwkoV0cgB6LSBWj3oLPYbWAMkDxESF5qSb3nV7mthD4yd?=
 =?iso-8859-1?Q?9903LWKR1IV6Ex0P9Xia4NkClYC/oNl3tjvgLS/9SqAG0PZ0NjsYuiIiZE?=
 =?iso-8859-1?Q?80cDbMNsnlZgYqNHP2s2nXGuu/NfOBNv6+QZ5jaJuYBxbod/UZKA50Abe/?=
 =?iso-8859-1?Q?2sgsOF+gsfFtg6CIA8jBHFATt+v9SLzJFyJryD9kN/rTvUpGePlb5pBiQQ?=
 =?iso-8859-1?Q?PssyM4UyPPeWmxlLSTw80ko++etDWf67FAYIe0IBJJb3d0trMRc7H0Plx/?=
 =?iso-8859-1?Q?jRMOSnf225ovYhhkA2z3sMJHKg2Hy3cQHuIEmJCgXjlJaKpci4FkKyidQ5?=
 =?iso-8859-1?Q?c+eQ9xbgULM4Idv8E4DvTfnlM1po6yaozJun5v/lOGU6aBO8Hh/n12hwO+?=
 =?iso-8859-1?Q?+pyi/do+FYspmj5lV6stgpwcHH9MRK3V/YJwsH5GC4SpgpUfiML8yILCMp?=
 =?iso-8859-1?Q?ZJUkGm0JCj+DXs6pDAKGel/0pWNMna2OOOSMK4G3SnNv184/gyz55c6Mcq?=
 =?iso-8859-1?Q?jCyjHEuhA5ha7oNrEsvTUL9xiXnLJQWLQItB+oM3E0bzXzzDsV68kaqE1J?=
 =?iso-8859-1?Q?6YYLDcAwOTK12dW2voRg8TDCJsv9QJKYpnLNrjHmzZpLLDgniPpnk6gNyJ?=
 =?iso-8859-1?Q?eph3bjwfQ183enPkyJ7cnWg3lWgwrkqoFzMNVBBH90hQYHGiRuxjPkXl6Q?=
 =?iso-8859-1?Q?iy/Ccf8yVI7XiawiUo5cz2zEukFx1IJToeiwIqks/nmFwfc//LwDwtOGAm?=
 =?iso-8859-1?Q?9cl8lhdg/a8bWJ297JDVbUR+QcHTsHzFmJVFjv1DyZL8fex8Ek1RMGTB/H?=
 =?iso-8859-1?Q?PF/tvCYbhk0qq08pIKB025+63ZPRGj1q7bggi5C/vt9XyYK7ViJRzImU6d?=
 =?iso-8859-1?Q?ktamU5kUeO0/yI3ty8e1y/xvQrBjwj4qBw5Ww4U9wVYye+iMn+d0IV/9VW?=
 =?iso-8859-1?Q?srNi0bKEtN8/9JNUrsdQmY/7iyAt/zoeZM1uSBS9OVvZlROvGzqbDFj3X+?=
 =?iso-8859-1?Q?EOCosD2hTSs+5nueVkyP/TxzcCehjmq5lM/ebSq7F7VbOSz/xuYTQ7QtJX?=
 =?iso-8859-1?Q?ZQ8kCSzoMmEugYaUlvQ=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4471b21-962e-4c5c-aa8d-08d9eca37793
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 14:41:48.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GHaOPhpxYGpiShinA9Lyo11OJ4mYIpLCDYAy6U4NCKI0HVH2nF4vPcn2ORsqK8hMhS+to9hy7/egUuJrdxO5XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3167
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 10 February 2022 15:20:56 CET Kalle Valo wrote:
>=20
> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
>=20
> > Hi Kalle,
> >
> > On Tuesday 11 January 2022 18:14:05 CET Jerome Pouiller wrote:
> >> From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >>
> >> Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >> ---
> >>  drivers/net/wireless/silabs/wfx/main.c | 485 ++++++++++++++++++++++++=
+
> >>  drivers/net/wireless/silabs/wfx/main.h |  42 +++
> >>  2 files changed, 527 insertions(+)
> >>  create mode 100644 drivers/net/wireless/silabs/wfx/main.c
> >>  create mode 100644 drivers/net/wireless/silabs/wfx/main.h
> >>
> > [...]
> >> +/* The device needs data about the antenna configuration. This inform=
ation in
> >> + * provided by PDS (Platform Data Set, this is the wording used in WF=
200
> >> + * documentation) files. For hardware integrators, the full process t=
o create
> >> + * PDS files is described here:
> >> + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/README=
.md
> >> + *
> >> + * The PDS file is an array of Time-Length-Value structs.
> >> + */
> >> + int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
> >> +{
> >> +    int ret, chunk_type, chunk_len, chunk_num =3D 0;
> >> +
> >> +    if (*buf =3D=3D '{') {
> >> +            dev_err(wdev->dev, "PDS: malformed file (legacy format?)\=
n");
> >> +            return -EINVAL;
> >> +    }
> >> +    while (len > 0) {
> >> +            chunk_type =3D get_unaligned_le16(buf + 0);
> >> +            chunk_len =3D get_unaligned_le16(buf + 2);
> >> +            if (chunk_len > len) {
> >> +                    dev_err(wdev->dev, "PDS:%d: corrupted file\n", ch=
unk_num);
> >> +                    return -EINVAL;
> >> +            }
> >> +            if (chunk_type !=3D WFX_PDS_TLV_TYPE) {
> >> +                    dev_info(wdev->dev, "PDS:%d: skip unknown data\n"=
, chunk_num);
> >> +                    goto next;
> >> +            }
> >> +            if (chunk_len > WFX_PDS_MAX_CHUNK_SIZE)
> >> + dev_warn(wdev->dev, "PDS:%d: unexpectly large chunk\n",
> >> chunk_num);
> >> +            if (buf[4] !=3D '{' || buf[chunk_len - 1] !=3D '}')
> >> + dev_warn(wdev->dev, "PDS:%d: unexpected content\n", chunk_num);
> >> +
> >> +            ret =3D wfx_hif_configuration(wdev, buf + 4, chunk_len - =
4);
> >> +            if (ret > 0) {
> >> + dev_err(wdev->dev, "PDS:%d: invalid data (unsupported
> >> options?)\n",
> >> +                            chunk_num);
> >> +                    return -EINVAL;
> >> +            }
> >> +            if (ret =3D=3D -ETIMEDOUT) {
> >> + dev_err(wdev->dev, "PDS:%d: chip didn't reply (corrupted
> >> file?)\n",
> >> +                            chunk_num);
> >> +                    return ret;
> >> +            }
> >> +            if (ret) {
> >> + dev_err(wdev->dev, "PDS:%d: chip returned an unknown error\n",
> >> chunk_num);
> >> +                    return -EIO;
> >> +            }
> >> +next:
> >> +            chunk_num++;
> >> +            len -=3D chunk_len;
> >> +            buf +=3D chunk_len;
> >> +    }
> >> +    return 0;
> >> +}
> >
> > Kalle, is this function what you expected? If it is right for you, I am
> > going to send it to the staging tree.
>=20
> Looks better, but I don't get why '{' and '}' are still needed. Ah, does
> the firmware require to have them?

Indeed. If '{' and '}' are not present, I guarantee the firmware will retur=
n
an error (or assert). However, I am more confident in the driver than in th=
e
firmware to report errors to the user.

If there is no other comment, I am going to:
  - submit this change to the staging tree
  - publish the tool that generate this new format
  - submit the PDS files referenced in bus_{sdio,spi}.c to linux-firmware
  - send the v10 of this PR


--=20
J=E9r=F4me Pouiller


