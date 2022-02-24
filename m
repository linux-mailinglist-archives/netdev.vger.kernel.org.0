Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1F64C288F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 10:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiBXJwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 04:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbiBXJwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 04:52:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B6227FB8B
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 01:52:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21O7iKgS014635;
        Thu, 24 Feb 2022 09:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=xNBB8Ln8USVeEqyZe5ivkR+SaEHSJn0j2/d4soXSleU=;
 b=T63SbRC1/tMAUEtfF/qHnjis6ByfKEOtaHPf4nuGOw9XSQ2ta7N7DSN7xhPygkSBG5HV
 3RfNsaBc+SdW4gl0gMk64XD1IOUq64y0L9ldqHYyQgl46Shfn0H0twqYoBkEdrdIlIbl
 Pa6RDb7VqbZ+MXezFTqBnwEoKJWhsDNzhyyJxR+LLdQmq3WaEPs1DK/nnrCElZsZCvXg
 9AEZIictWOx9TUKzt9006uiiJDPlnJDMYXql9Ibey2PPexdavAJW6fPIPLRMyXLblAK9
 UEfevSNixeFxYtKYekhOd75bA22OOs8HSOaeLCybye94OjtwwwXLbgVfZcoJG+l+mC/k mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecvar6gqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 09:52:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21O9owgu084495;
        Thu, 24 Feb 2022 09:52:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3030.oracle.com with ESMTP id 3eapkju5yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 09:52:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAZQKIEPqpKLTpa0g8OfamHoak12xDnrDaq3XWc+DpsUZ33NU4/9xSIkcX1kmCSn3ruLI5xVtpGHAokGRt3rnDBCVvP0foC1jo2aDxtiKFqiVGWS02bZKKgGpqsu+NPBQpMa7VNZjgkfnmfJmpb1cJaTqqAZUf+3HZvM2skQuyXrQUZiY8zGb7GKoiktdbIJW8k+hHU9aUN4luoz3b16Y7IbeTdYQ8SqEXQ9hEXYGjQdHvGPqjR7UXsMQCoFmzyMUCC5EB9l+tSQzzT+x8Xbd4A+rt7QxqRg/s20P8+woZhOITtVEXGsPY4zvU/7AxddLIsuQxyAuvOoMkA15fV+Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xNBB8Ln8USVeEqyZe5ivkR+SaEHSJn0j2/d4soXSleU=;
 b=BudpZs/7FvViyyGdZdEGD+HmVN+z4amU34jSjlS4DpLSWQb7jaQinW4peHCMFEyUNz2ROzUaWkjNLCLiiN/SphWQYMDttBaBEAq8b1cgE0MAeEwTWlhqCVjw2ap7xZ9mjmRksJd1/m5e6e5QchKmmPsmqzJX9ShETvfhFIRZ9jnBf8PyOx7VEbxMZsIX/+LHGGIfjCH9UQEEhGa7G9WhhfOYLR8y0JX1uU+2aH1FV1xIx3nsjPNcsOy1r4Nvjbf0n4H8w9zztL68AvRcovJD34Kqy6bGMXzWmZbp/BwMwl5YLXhc9Mvkqk0M7zxLOdmXejTD4c1JmC/5mckuci9BxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNBB8Ln8USVeEqyZe5ivkR+SaEHSJn0j2/d4soXSleU=;
 b=TgK+ffhuCPv895C6Tv0aA+QZVfF5pUg6IuP+axNUfGOcpvQPWR+FRHubr0/Hh57xgtCiqP3oTgMVCqgcz3lUzkAKiYX4JAgS+3fopXDhDX/RAXmxxhPo9cqsGlrIh/7yBpATfykkTuSj7HgOps3d/eadMQDq9xJqRIEXwCtEMZ8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com (10.174.166.156) by
 BYAPR10MB3639.namprd10.prod.outlook.com (20.179.63.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Thu, 24 Feb 2022 09:52:03 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Thu, 24 Feb 2022
 09:52:03 +0000
Date:   Thu, 24 Feb 2022 12:51:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     matt@codeconstruct.com.au
Cc:     netdev@vger.kernel.org
Subject: [bug report] mctp i2c: MCTP I2C binding driver
Message-ID: <20220224095154.GA32007@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0182.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::15) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd549674-6d62-40a5-b285-08d9f77b4f41
X-MS-TrafficTypeDiagnostic: BYAPR10MB3639:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB36394DCBC19C07A0E1F967C58E3D9@BYAPR10MB3639.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EwYY3RZxXU9hCySO9rD928h3dyBdOVLy4dwvmRjsOkpvxf4HWzTGZl5aTpQt0nkuAjot0cXd8z9OV8vFXrcHuCtQF7g46u/CAYXtgmJSvJup1kUSUrY3j4nZ6Bhe99KPS7qYzcqkVt7W6lOVQfjUM2HjTCnnIBxn4rDGrkx8Gsx1YWFd7pj7ggPzYhFSDEBYiTs9d+Nf0r99SarICW8If3uKHiAdhp61LwnY54AOGFErZD41c98B2OmxQs7dSPVghN+Tr8I0xLfrshSrdFiCMndur5II9bLAtWcpXA7cfAYo19RQkOxJKZ4ZW3YjZ+Z0Bqmo9x+H0seuIL+hu/lAkSdDSII6yCQXRq8mct51uKXyhpo4xVV/JJs1GQTTtrSJfVCuNPPE7rNNBYSo1CW5t3sEXBi6+2CmWRVr+25YGdgVjL39hfVnOxeng8dVVgTHDAdwDkuNo8C8In9kJ/AxKakMZnJtkNwgBFZeIIHHhWJjhe5tn+y2IwT8ex73a0pWjfJufig6XE2ZdJtpN9ntfYycIgFgSfbAkb+e/8Y7EKUDtTijwTIFf56THKEpKGmCOnvTQ9pMG/NvGBB7NicncBSQYWYu1jRrXkVP6WJtbkLReuCAeD1uVExFot3Cttudhxg+ABIjdjx3Yr58x+RhoeJROurLciCbn6WsAYaqozVrfgXrP8UAlDKUW55Mn6aMReuYLQQSVfPhl+wJ+U5HBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(86362001)(2906002)(6506007)(52116002)(66476007)(186003)(316002)(44832011)(6916009)(26005)(5660300002)(8676002)(4326008)(38350700002)(66946007)(508600001)(6666004)(6512007)(9686003)(8936002)(83380400001)(33656002)(66556008)(33716001)(38100700002)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FrdumgQiYG4PMIy63wM7Hq8f4I7VrGsT+2FNeKqBTKE+DHia2qQ9hTRxcBZg?=
 =?us-ascii?Q?I8ZlbvgwN/smExV+MLpenv6LvINA7vnpqSx7S4k3IWzUUt7Cmd7RnfNkwm4D?=
 =?us-ascii?Q?QrHCOOoXa4sZvu8pIys41lFRg8awB3pf8KPvnil66gHqLsARWYPau9kFeuIB?=
 =?us-ascii?Q?TCpF+oyjl2D7mkqW3bW8P78QX0dLvUYiIj5LogMrO4/sIcIjDJTNkQzsNLd7?=
 =?us-ascii?Q?8BsXc+g0q3lbUai5Op3AYdG+4FMlT74py/KooCt9h/2WKsSY0uMFS6yKmF9N?=
 =?us-ascii?Q?2UPKVsx4jwjNMRk+KlcpaUFHELPOi4Jg6XqorSM7kbmlfPZkKeoXWGC7ngI+?=
 =?us-ascii?Q?uMPW4YhbCHu12Qt1itBOz/CRdElIbB5CM/12Ka0PKPnIwMbnVq4PGPp+iGTn?=
 =?us-ascii?Q?q3Z9u2YZ8szgdOahwIAS5cMFn+M3J8N2Of1vEHnHFaA52pCrCMcMDZT2t2gL?=
 =?us-ascii?Q?8SSG3r7X1Bs7AGUTHoVNAs562oco+buXT3ZiM45DVmfpnIi6VpYAGCB5Vz4b?=
 =?us-ascii?Q?IonPtUVHNb7m2cd4DZVscA9CCu2LmRzHDgFBL3yyEH4hCgMVkSlCvKGE+3sR?=
 =?us-ascii?Q?bPJHNVh4rmS3SMwVPCjK3uBbP0rBbDqUpXYvPzGqxcJ/p1CDxPnAaZvi+pNG?=
 =?us-ascii?Q?HJpVCgAyp1LRY2KW9T3tjrBR3Ayz0NdzOhA1/kYNi10NPAWCixBDU6FZ1RAi?=
 =?us-ascii?Q?PSX7zx3RaHyiXKbio1imph9u1WtO2t6iB5fCQKLic9nPt27a9QdyEwttCF4y?=
 =?us-ascii?Q?5TM2M0nDUrSeE8qvjAbglxVN/RcGMQHLq8bHjLKxWZvfInW1hlTjoupLsdp3?=
 =?us-ascii?Q?IHStQVAlSr9zAIwi8fGY9GbqosBbg27jRVEcufUyKWLdntDTUKOzA7M5apEr?=
 =?us-ascii?Q?bms2Dx3FaF4txD/AdMHZq/W2vY+920gIx03aFcywGI+5m4Qx/X0ziMs/cOs/?=
 =?us-ascii?Q?faI6F4Mh4iwFI5qVxnaonaU2/AS2zF8XyzxFx0IrH96EN83PDkP80dNBrVI/?=
 =?us-ascii?Q?0AiHlB8vYmPUb4wfl/2100LYjcoljbBb/TH4kD7VPu3f+560o/byIIB56pSx?=
 =?us-ascii?Q?y6+eXNANaUXuiF3BOCFlblfIXEB4SrjUu6tX8DvtGFa6fOu/+hKAjV9RhifN?=
 =?us-ascii?Q?MpyOWx2hFYQKbBMJ5yV7hqLo8P0EPAT95NuBawLYv3ZSDxurfQZNjY97cygE?=
 =?us-ascii?Q?1f2AuR8wmXsyE/hn+SanNM2HpnUB+xuTMQOu+wzg9bwAQFfsRTijgHe4cEpX?=
 =?us-ascii?Q?zn+nviFoDu1YwcEjuDhz/NSa1jzZSRFeBK9QBB3d+oIX/enfMhqU4jK7O1kN?=
 =?us-ascii?Q?AcOCRarP2HQ55SPFLUV+H8BNBqEWXiBO4vnu1o66/eWzmR9gFTHCSK88Edbt?=
 =?us-ascii?Q?QyQnxzTQsOkn2DqJeDvR2y1geBEWgE3T5xMwA07ZC6iDL1uTKsiaUrR4Vj64?=
 =?us-ascii?Q?JbwAQ19AEVbbzGkIW3heU9nfU5FtB/Vrd8cQr0Dxv8B8eth8901MxLlDoeqG?=
 =?us-ascii?Q?lVAf3qxFZYdjkAubB9TltiuuL2bMAfdPtjqXpZ1oJvTlbXVzgEHWZzQX1R7a?=
 =?us-ascii?Q?z0W/CupWyKeIKb2r6h9ISwbPpSPDiUwvaKv2p2QQyqkfSxL6VYKHfRjZbJ3x?=
 =?us-ascii?Q?iA3QkYjYWwXpepYO0Bn7/2AOtpUhS5hK8XtQfY3K36WnEoKi887U3NXsWXto?=
 =?us-ascii?Q?GBF7KQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd549674-6d62-40a5-b285-08d9f77b4f41
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 09:52:03.5504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6p5I0+LtZu20JgilNWn1DGXCRTe12Raibwr3HuLTy2En/KS1Kkw1Mr8ndlKwNxSd0Cde/zhRiZISqLL5mRg1CnOARaBIN/P3DhDkjso3Fyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3639
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240058
X-Proofpoint-GUID: 2JWzjMT0hes3jaT-dWaqLfBShDL47Ulh
X-Proofpoint-ORIG-GUID: 2JWzjMT0hes3jaT-dWaqLfBShDL47Ulh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Matt Johnston,

The patch f5b8abf9fc3d: "mctp i2c: MCTP I2C binding driver" from Feb
18, 2022, leads to the following Smatch static checker warning:

	drivers/net/mctp/mctp-i2c.c:341 mctp_i2c_recv()
	error: dereferencing freed memory 'skb'

drivers/net/mctp/mctp-i2c.c
    271 static int mctp_i2c_recv(struct mctp_i2c_dev *midev)
    272 {
    273         struct net_device *ndev = midev->ndev;
    274         struct mctp_i2c_hdr *hdr;
    275         struct mctp_skb_cb *cb;
    276         struct sk_buff *skb;
    277         unsigned long flags;
    278         u8 pec, calc_pec;
    279         size_t recvlen;
    280         int status;
    281 
    282         /* + 1 for the PEC */
    283         if (midev->rx_pos < MCTP_I2C_MINLEN + 1) {
    284                 ndev->stats.rx_length_errors++;
    285                 return -EINVAL;
    286         }
    287         /* recvlen excludes PEC */
    288         recvlen = midev->rx_pos - 1;
    289 
    290         hdr = (void *)midev->rx_buffer;
    291         if (hdr->command != MCTP_I2C_COMMANDCODE) {
    292                 ndev->stats.rx_dropped++;
    293                 return -EINVAL;
    294         }
    295 
    296         if (hdr->byte_count + offsetof(struct mctp_i2c_hdr, source_slave) != recvlen) {
    297                 ndev->stats.rx_length_errors++;
    298                 return -EINVAL;
    299         }
    300 
    301         pec = midev->rx_buffer[midev->rx_pos - 1];
    302         calc_pec = i2c_smbus_pec(0, midev->rx_buffer, recvlen);
    303         if (pec != calc_pec) {
    304                 ndev->stats.rx_crc_errors++;
    305                 return -EINVAL;
    306         }
    307 
    308         skb = netdev_alloc_skb(ndev, recvlen);
    309         if (!skb) {
    310                 ndev->stats.rx_dropped++;
    311                 return -ENOMEM;
    312         }
    313 
    314         skb->protocol = htons(ETH_P_MCTP);
    315         skb_put_data(skb, midev->rx_buffer, recvlen);
    316         skb_reset_mac_header(skb);
    317         skb_pull(skb, sizeof(struct mctp_i2c_hdr));
    318         skb_reset_network_header(skb);
    319 
    320         cb = __mctp_cb(skb);
    321         cb->halen = 1;
    322         cb->haddr[0] = hdr->source_slave >> 1;
    323 
    324         /* We need to ensure that the netif is not used once netdev
    325          * unregister occurs
    326          */
    327         spin_lock_irqsave(&midev->lock, flags);
    328         if (midev->allow_rx) {
    329                 reinit_completion(&midev->rx_done);
    330                 spin_unlock_irqrestore(&midev->lock, flags);
    331 
    332                 status = netif_rx(skb);

The netif_rx() function frees the skb.

    333                 complete(&midev->rx_done);
    334         } else {
    335                 status = NET_RX_DROP;
    336                 spin_unlock_irqrestore(&midev->lock, flags);
    337         }
    338 
    339         if (status == NET_RX_SUCCESS) {
    340                 ndev->stats.rx_packets++;
--> 341                 ndev->stats.rx_bytes += skb->len;

Can we just do "ndev->stats.rx_bytes += recvlen;"?

    342         } else {
    343                 ndev->stats.rx_dropped++;
    344         }
    345         return 0;
    346 }
    347 
    348 enum mctp_i2c_flow_state {
    349         MCTP_I2C_TX_FLOW_INVALID,
    350         MCTP_I2C_TX_FLOW_NONE,
    351         MCTP_I2C_TX_FLOW_NEW,

regards,
dan carpenter
