Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564B33C8026
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhGNIed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:34:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61284 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238527AbhGNIea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:34:30 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E8PLQF007070;
        Wed, 14 Jul 2021 08:31:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=UyUFG8byOOKAO9neE6auPKx0ExBn33HerhNNoKv4yUo=;
 b=t+mEaxcFEhLyQNLVaDh62Dtt1P7OngN5ACwsv2cmexJ9b71JJQVM7NG3hzpBL2/EG7f8
 FFBenHZbPK45UFW7PCs/oYV98zA1xXGAsXNiYAgmrSDJjeVZFUNceD0weTCvCydqHIhp
 kBctUZK4065tsLGBQ69LXR8cmAjFt9aa15thkePlN7qxGW2bP9uyqkU2E7pqIbShjeAV
 bsI/Upyh4at95DTwi6Oh2KcVgx+mSQDwvYuMieMyWRq9utVosuHI/oA/2sX8YzoSf5Wm
 XgxThn/1XXsGjlvkh6MNXOgh6gWU5XJg23utMp6L7E6TW2StxxEMuBUpsUSvYRcyTo9p vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb470j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 08:31:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E8UbP1133132;
        Wed, 14 Jul 2021 08:31:23 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3030.oracle.com with ESMTP id 39q0p7vnxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 08:31:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrfDuw/hlol1c0xYCfpiGjDYpTS6bwEjkRcNHgeS0v0sobU5klf0IYGIoiHUNBuMiOHv+/+MJZ3x6FQO7zLWfAALTT7nfK5mA6jtMFG+2ql8RwFFWgGfW0NcolAxmMg8RSNoAan+DtpCmFaoShlyxdJH2RuNpIFu3YgQkM924YxqSrnc9OXYh8MJlR/1Z99oFhI14dOK3dH/wPsb8O9a2Y0qojeuBbhaBIT99vKIuv3l1F6vAT1YaCjnhmtUGaozESnCvDni0vDErgcW1Td50CU//ksWP8WCZR/pUkbATEcg0uzINtwu7IKqBsF1EV0ijTIy5YEOJwVZBGAtaievng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyUFG8byOOKAO9neE6auPKx0ExBn33HerhNNoKv4yUo=;
 b=HlVp4bnB6adejNKU4kqjhL3VBv/+5mCtx3qBCSGpM++uKqvLJqBNUoF1EHLcTBxaoSbIgMvmcSi164UYx7xLYpUa7FuRIhBqyLg9bhVXN5ApFxz1+zFfZSnQmy4PNv1ZRceMya3NdLEOcvJbClTY31pbX5zZIvryVO8QLnNK/13HqqWH37L9YvPHsz89+2ny9H0Dqj/qjbHxfaorsVelVb25kJASXH+MQuipegReMyavpWIDcz2Fv/2d8imTYrnNzSuJdytuDby8GamqFbyF3o9zVIDLN+DWbGaWPE8wNIbyZ7MTDC6uZAUzwtSzIEEW1olrePRvnWsegM7p8N7Thw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyUFG8byOOKAO9neE6auPKx0ExBn33HerhNNoKv4yUo=;
 b=JTzH4msFDXGjYBsLSKsZ2vdfu+V13YBJwCnHCcO3hYfa1zyT3cwU9YhAplllK9rHfni3pnFGVbVrVlQ0rIWhvTkyvbTyHz51JDDXvrQMkkLOPAJFtyZFRCaAEMTiz6uMlLIUWlTPqeb6jN0UKAlfLLq7mhftfhg+vli6gckxd0Y=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1422.namprd10.prod.outlook.com
 (2603:10b6:300:22::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Wed, 14 Jul
 2021 08:31:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 08:31:20 +0000
Date:   Wed, 14 Jul 2021 11:30:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        linux-usb@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 1/2] usb: hso: fix error handling code of
 hso_create_net_device
Message-ID: <20210714083046.GX1954@kadam>
References: <20210714081127.675743-1-mudongliangabcd@gmail.com>
 <CAD-N9QXRRipmyOiUFDx9OdM47c37Y+oAa+T-ntZAGZXrd8MTrA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QXRRipmyOiUFDx9OdM47c37Y+oAa+T-ntZAGZXrd8MTrA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0021.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::33)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNXP275CA0021.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 08:31:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e102d7e8-3976-40ae-ed3f-08d946a1c173
X-MS-TrafficTypeDiagnostic: MWHPR10MB1422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1422D0DE39B2F940813421808E139@MWHPR10MB1422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k/GWay70FbzZimXjA1zrnlT7mdmGz30/sVuyRRj0t5mP4s1TcexHdQWgn7TqgEmCd0C2RiSbPFn2w7/h5X6N6s5dzHQTLOUpvRNpLWaFYVXLdpN8j/YO/Q/q6nKtuq/fz+hqGv4SZ4PlBcHE7OLU7+/BNNnW0C/s+wEMtXfjEqthrDT8ibTLf6icmNQZ9ylC/80jrvhIH79ueH4cY02C/ziKtrHuqeGRgvlwFggRwfQ43wseusKRDdY7wYm2MBn4fH6Qj9y1ml2x7WAffXZgydGc7OZqIX9uxHtTyZrQMMREPn5poB/P3NGNkiNUgYDmPJEMy19NOp4fj0k/794nJPIvhWHZda+7awkqrYil3+1zhrc2N14jwiy8QRJ1b/9ZBfU1+0A+0w8gEF43yMi0BpU9U+Y6EI5m3AV7JUxALXg/VtNeA28dpaVZ7T7zUWqO906dMFh06TjzWbH3w65mGJE6d5NPw1aoNW8RDnYQlL4h2PmCR7MKzhxHGZoDjrYfQcrImE5khaxPlTfctEV98bb8OwwDuaA81T33v+r0yf5OXp0CHuUDAFRyqUlSdr+v1M3h6EcW0wbgE7DwAFAX1khbDv+7Hzf9tjsQ49Of2Cmyw2HpkRll/qg+WUnSECKbt0HO3QHwffH6AdusFb+lmEOj66QQYSoePv3NyNhpVY29X7MzsN2kmIHdM2vYadC4zS5UPXKcLvccoUrj6tHQ1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(39860400002)(376002)(366004)(52116002)(316002)(8936002)(2906002)(54906003)(9686003)(38350700002)(6496006)(8676002)(55016002)(6916009)(38100700002)(7416002)(9576002)(26005)(86362001)(186003)(4326008)(33656002)(44832011)(478600001)(956004)(66476007)(33716001)(6666004)(66556008)(66946007)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?35w3l3ESVbnfvavTKHp3WK5SpjPbCJQUz5ta4A/8/2fEgWUZp/U2OIgmtY8/?=
 =?us-ascii?Q?dJ4EYGLCTZshoY08z3SSBEry89ARgB6uKeCLNXlAqWeKy5AhrO8y4hJtJAAq?=
 =?us-ascii?Q?294v/RibbwLT8vkUXcwiJOlC2hgByPKFXuxo9inWMmoZa7rurmczo/X3uxD+?=
 =?us-ascii?Q?myUHN+48kdC7j1FhRaXXtjVpvAP3W7mMJY17gFj3BsjlYSgVnTgopruDiW0E?=
 =?us-ascii?Q?fcGo2wyasQUs2TwzZ0R+v9VVIDGI4RjfGBN/dT5+aPc6ufV6nQYVQg50Sey3?=
 =?us-ascii?Q?/TCRBrl6DgtSPDOlOeb9z2Ycd+Wi6qWhO95Gx/p2v9mLwEXKUBeAJVsu4DT1?=
 =?us-ascii?Q?EmouuVxjFfVN7qT4k31DSkTNXsk4lKa2gzq4tzCtUWcEwtGiSks2VnysaD9s?=
 =?us-ascii?Q?pE1kv/d2BlMzMfnMLiJxH/bBmbAZ0kxfBwUmjo0KfxAAYO089IHhiXxWoBQy?=
 =?us-ascii?Q?cxmlDPlEu6gcMDxhohTivTaBvZMmQdmJejf5xFjDfrANUK/CMJu2y4IOSPY+?=
 =?us-ascii?Q?FjX6kEaQl+EELMz4ByOyEBv91ish+i7L7B4eyYybUIEvyM/FczCmt3JZBuTz?=
 =?us-ascii?Q?oPqj98raJdHFqyWn2/tOk9Msd8Si+Sb6o/wVNltaf/gO9DZENWsK5AX6WGuj?=
 =?us-ascii?Q?5AqPw2PzZELmqeRhZvQ3tmeoiFhRaFPl/89T+tLY0EE5IS3O5+N4XKCstvcN?=
 =?us-ascii?Q?hQhc05zbH77BDvurVbSVYRM870ZICLhCmQhAESpCoGUx627X3iiNyUemFQli?=
 =?us-ascii?Q?cV+KQFcu1gR7KqUPhqd2xkUfTofEALK4ZvPQiK7pCoZ9JNhC82pYob1GCahj?=
 =?us-ascii?Q?8zqWwCQiSzCsckJD7DZQtlPT4DX+VUXBPjJZ9s96tjZz4pncXgOdtaLwhjXQ?=
 =?us-ascii?Q?fmQAHYR5yxhzxMKl3DoRBA1PGhsPFbeO5c2C6USepnI6qlBfQG0jUH7Fp3a4?=
 =?us-ascii?Q?CrA91+dr63uxwMtP8HKB92c6hfardvlSEsmSpZu+/0FeCIfswbEOE5c2dlN8?=
 =?us-ascii?Q?5u6nHTB8Ad805nN6qe1PQniVGjxm9VSPcnsULWZfXsG/HkddwyyCj//2xIAj?=
 =?us-ascii?Q?wTArQSBnhgA1pXmrRo3vd0+0L84yHcnI3CHgbKnaIPAmtlvFXNfSltC7OYMB?=
 =?us-ascii?Q?XoYzWoJA3VfyTXImiNDBgENYOcuOmsrf1ziOojXTPTbwL7rTTWphA7lXi8iu?=
 =?us-ascii?Q?A2QbBYshyQLELC2/sifuPMwRDjxEZl6muIxO0iPjFIWPVcA5ATLAJSRS1+jo?=
 =?us-ascii?Q?6u5okNVp0YhudDtdU1yhDghAzvwKG0EEhMyC1fJtf5/O4Idw1Ssstvr+QIm3?=
 =?us-ascii?Q?1C0WuQWOIsh/sCafscYnTf2i?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e102d7e8-3976-40ae-ed3f-08d946a1c173
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 08:31:20.0773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q6oJeT/eS2n/zg550K4t9TaKQ3r3i1ZiNbAQJBJTYoYtzfoDogKs6jjp4tY73EIWtQciqXnGOryP1tYccP/EtfeWpyAvXTAtB62aqzf15zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140055
X-Proofpoint-ORIG-GUID: XG3KShYjFwQoQqWF2lfiqkWRXozRHL8m
X-Proofpoint-GUID: XG3KShYjFwQoQqWF2lfiqkWRXozRHL8m
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 04:14:18PM +0800, Dongliang Mu wrote:
> > @@ -2523,18 +2523,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
> >         for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
> >                 hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
> >                 if (!hso_net->mux_bulk_rx_urb_pool[i])
> > -                       goto exit;
> > +                       goto err_mux_bulk_rx;
> >                 hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
> >                                                            GFP_KERNEL);
> >                 if (!hso_net->mux_bulk_rx_buf_pool[i])
> > -                       goto exit;
> > +                       goto err_mux_bulk_rx;
> >         }
> >         hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
> >         if (!hso_net->mux_bulk_tx_urb)
> > -               goto exit;
> > +               goto err_mux_bulk_rx;
> >         hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
> >         if (!hso_net->mux_bulk_tx_buf)
> > -               goto exit;
> > +               goto err_mux_bulk_tx;

I would probably have called this err free_tx_urb or something like
that.

> >
> >         add_net_device(hso_dev);
> >
> > @@ -2542,7 +2542,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
> >         result = register_netdev(net);
> >         if (result) {
> >                 dev_err(&interface->dev, "Failed to register device\n");
> > -               goto exit;
> > +               goto err_register;

This is still Come From style.  I wouldn't have commented except that
you said you are giong to redo the patch for other reasons.

It looks good.  Straight forward to review now.

regards,
dan carpenter

