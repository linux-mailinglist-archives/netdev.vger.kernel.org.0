Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA664D025A
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 16:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbiCGPDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 10:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243463AbiCGPDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 10:03:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2160213CD3;
        Mon,  7 Mar 2022 07:02:45 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227EhPPT010128;
        Mon, 7 Mar 2022 15:01:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=x1Z8v8EkivpLkEtwJQKAOgXpTNObPmq0E2YTEG1eV80=;
 b=Dg9v6mq3ZY49K7dv8mVx+7YTXcu5DpYlLSB56tB8Lv7c8vUKEuAC+Ln+DGTfeAsBLPbc
 HsLsgriLDJ6yPnDEiJ+JAvFXLiWaRSFRITBgZkhxxa1KJ88Lx81LPOxVSVWo2/sI2smE
 Qk+QqZJ99YwmFUguJpoWEeaES30pTwTrF9EouzWH+MUwiH/9QSHWlboBHy/g5GqWn9Dh
 nqrs/brqswoJ3H76eZKtgTZ0Zte2rWSqq8IeDW1TROSz/LVzycXddxzaLXSKofKJwwn9
 0LX2WGlD8iHTz11FLpDqPc0HLFlRX3eV4kt7alsIdTiAw+TuafbLMtKtRSl7NwvFvRUA dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cc0uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 15:01:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227F1YB8182831;
        Mon, 7 Mar 2022 15:01:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 3ekwwb2ceg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 15:01:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVxJCQH5xNzO3rnfAv830aUd7WYux8KegXHKjztVeeuY0Psr1rQHhg75Db+FsMCz0FiiZsf35jkHeMdxUqhhAoTula8BUaRj7pTs/65NHjz6BRvHhtApD7yxSd2SRpFCuxFgQn9D4PMo39iPUj4bCTUPnttCwfzCuxARP5DLY858t/juyFyBQlEDsdN6C05vyeJADD+7m5ntFvexeIu6BcUbSyEsjyikQSMG/stuDpSoUTaifnr5k+jON94hbAymivJw+ar9ps3N6xTi8tizrBeebQT+3dwgyJUj7nnNxE5hP58uauTpcgeEem+tiQRgCh6VGJx8oCozqYT4UJ878w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1Z8v8EkivpLkEtwJQKAOgXpTNObPmq0E2YTEG1eV80=;
 b=T1RBS/H4uxN+ed6NkiG9eof4AnRTtgXwT05Anuk8il8H1ij8v1e0UrftdhvCiw6fp3ZWNqwT+mPWB3mTK/PrA+IYRltCpfFUwmDgJU6ozBaTFXEjK/LPnY74RbmnJEYiKv65G41bjLZ+IFhxZUN7r87iN76OO13/3XIDQUo9Rw+V9cRBMkvL9z/SkJrb2xKoHC25ZslkEktS9tYOSE6edRrZfsLWQ3Owlcq0B92Q11tPUBOiEX2XXBcmVk4aTybL3hLLQyEj5Rzeu1AIGHPkqMH2zcj8JghEhxgM5OqaSlQMv7qvI5f099AQBS1Onv4IdWhkb8y4B6rdreWySGIjuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1Z8v8EkivpLkEtwJQKAOgXpTNObPmq0E2YTEG1eV80=;
 b=RxwdW2rzDCZD0qWd/XaY98p+dmcfiggvHn2cZf4CURZpYtDt62oszWyey/oixeSjClOuHWh7B2B2HlO6iogDTrJls4Qmg+xSKBanhi98fi6rONd9mHcMBfDSa2NFnhm18wXVa/tlrq1kkT5GWOz16thid1PowWArmAhKZ0Fmb+4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3162.namprd10.prod.outlook.com
 (2603:10b6:5:1a7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Mon, 7 Mar
 2022 15:01:27 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 15:01:27 +0000
Date:   Mon, 7 Mar 2022 18:00:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sgx@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        bcm-kernel-feedback-list@broadcom.com, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kvm@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        v9fs-developer@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/6] Remove usage of list iterator past the loop body
Message-ID: <20220307150037.GD3293@kadam>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228110822.491923-1-jakobkoschel@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a790898f-2ec8-463f-3dc0-08da004b5aa8
X-MS-TrafficTypeDiagnostic: DM6PR10MB3162:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3162E5B690ED927B678D923E8E089@DM6PR10MB3162.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/fLTcENPy3FDPNbRhqURAmaW2b+qsga24wWjHAJa2bIyULxvWUIl2ol/8oP9OpffdCI9+WIU/mdnsgId0Ia5t6Y571afcH5tstavjRljpRPfo+54PM0gqPjoq828bWe+A9YGLh4zXv5yNSoCFUqx/IhBqVaONfo6avK+iwn3140w3noRjVXsjSXyS87BkBaHyVpEvOQzcX5L4l1pNk4ANAwGEatJJfh1jfUOz/vGFvi/BKEGTCNnnIpLeBlhtAhTts8DTrk18T/OlTF+JBJ4ikYzLV5MHKpRKroTDZhsLceSwaXwAOiAnNSx7t2MuAIgwwRX7ZQoVs43AgjsG+Fg6BLneQojEcGKiR6b2BGzKIgAzleffcWgpHQy9UoUVPk/+C3EIFr9UszIpi7TavCp2FHEtJGl/SVafQVW6aCWyoAHs88Luhzkj71LnU3wCLb4c+8Z3H1XPYjXL3h3uAoFIqzaNkjNcOSIAfbwQ6iuicT8Vki8+YKCR1aToL6Z8tugzM6uY24TmoT3SavWW+FJxQhewHw1CdSx04GF3NxGph8aG8BzAL/WvMnHz2nv5fZaY14jCvAxM2OD3mgGpks2il9IciqttjmkYqJdj2l5Ku4EwbO6Q/s4EoBojCoh9Ei2UGFxJ5LYiZlKSIt1GHfidLEcqmQ/F4bj6oYeWLtfBwd1h6CFc8cBOYZkpOeQ5imTBMIiyQoluLm/4ZVf1oQrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66476007)(33716001)(66556008)(66946007)(4326008)(1076003)(8676002)(186003)(26005)(86362001)(83380400001)(7366002)(7416002)(2906002)(7406005)(38100700002)(38350700002)(44832011)(5660300002)(8936002)(6486002)(6506007)(6916009)(54906003)(508600001)(316002)(9686003)(6512007)(33656002)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bWnw9vDUW8VZdEEeOBoLe1Y2rGYUV11qKNE9g6dxqMiuS87/ZyKsTccHFR0h?=
 =?us-ascii?Q?zsB0WiEiqlAdSnYChqWyixjeTe8J70lFdgZDxvpYY8Md1QJlCxc57WI3lKKW?=
 =?us-ascii?Q?7OKVtZZPwo4PQELlJDxenjkgFckWDcGxekNXoRiALgGlLG8LqMmpbMB8ekyf?=
 =?us-ascii?Q?G9MyP6chT/cDn70t0b0ueGN5RG+81wHOZAjBs8HDDvAaxhGaNbnfncAdt8Yz?=
 =?us-ascii?Q?qX72thiL+n24WSbMLcuBJJ8V1ccly/dGK5UDZGkFOFVT4AXyXoELapcqNS9z?=
 =?us-ascii?Q?NDhaaoIUKUexKB2+F4X5Y98PCgFTSNenrUz1PIjLEhyc3Q/ZE8sAIfA2h29O?=
 =?us-ascii?Q?bQjjNrixP+R7RSxpVCbbgsDGbv/ZATRvk3WhKWwb+jmrZDtXDwxLOMHZ8yBc?=
 =?us-ascii?Q?4pHu7DI8TyzkjqTF1upf8s5iN4CMqoFQdu4wUb7MaRHV72jMkEUXsFkASQSF?=
 =?us-ascii?Q?vv7Ac+6drIRQn/r1jQ982aqhi7u5vO5ZL+dEMNOjGriG3gC1OcYvZQ1u8c+n?=
 =?us-ascii?Q?g8NZ2LHY9el7yNIaIukR4Zm1ktcTCctIG4XS/pg46BXoL1qdKLQRRYagZFK0?=
 =?us-ascii?Q?/n7DreZfZaB3/y6z/AfBYEefukHPXeDe7d5ezAitzK+d2QQog4rIlDD8qa+8?=
 =?us-ascii?Q?zymgVQ4pYNtlCsnjeMBG+jeXNkGWjbBYLXnAKxwmjjZXhcMZumddOy+Ox579?=
 =?us-ascii?Q?4AO7+KrxbY8OaHng70JT1yHw7jJ41cKVMyj6+lSTTT0hY/vBD/EjaHX7CQGj?=
 =?us-ascii?Q?gn+ib54LqJK5ERUYLkPyLTr3fL3+8qVsU6VJuAMogYWficUmoqE1kgh3VfYy?=
 =?us-ascii?Q?5GG2gh3eUz3ZmDWGrWLk37QmW8AjdqWL331TJqq2Vtfi2os1mSDeNEMNgTfs?=
 =?us-ascii?Q?JigyK6JXXFG/AjbfCvKyxTb5b97bfuqzQYdE4eHJbcn0vo5hRiIhGLbJf54r?=
 =?us-ascii?Q?1+wj0BXD4HTyx09AT7V8I93fCvHTD4ORTHncQiR55MrEjVVVy2S/EZ4ptMEb?=
 =?us-ascii?Q?TJM0wnWIaTrGbKcSA81X6pV7ijz2Wk0PZGUl92KsTsSPo6c4I02gYNS2TSAe?=
 =?us-ascii?Q?K9VDwr5GETgPv8BUisSpiQzgq9JMAGL7ZnOl5wVX/XqKWvpIc07KZtQcXnwM?=
 =?us-ascii?Q?Jtjl9gkcqxAFpr/BjcYIaEQjfGCfJ6idypOOy3N2d/uEFFqMaOjZtDKDIYwv?=
 =?us-ascii?Q?oEIKeog/E7IrMTA6satUj+vLfWFpsVkMzFoWxRRR8DQAkSF4xn7i35zyuOiw?=
 =?us-ascii?Q?irH+K1abxkvnaTDv9ZoTXuNBzuRMTaGXYA62J39eVJbq3yJy0RQEPW6c0rcx?=
 =?us-ascii?Q?g4pKQAKlIR+gQdM+vVMBlpeZKtU9aKXqqCOO0sXGBz9wOH+Aj8leCTE7a3IZ?=
 =?us-ascii?Q?JCCfiA7fX21qLYfVF1XBAOUSvI0Ernt29iTu8NYZpO7IoQmKhLGZr4GbkcTZ?=
 =?us-ascii?Q?hiPa/2oyjB36rA+wClvc51mBbcVTEESLuNZYDurf2ZbK37ErAOGCOnXBlzO+?=
 =?us-ascii?Q?JqGgc+A6MF0WAnahTTJHEWvldUZikGnWltMXf1mxdNBxe2cMPy+SzwaHv47W?=
 =?us-ascii?Q?Ezb+s+3OJuV1G7JHkGx4LKYHG8u/EbA6EEPLRBhVPvvFEpozXSOWy4gopb23?=
 =?us-ascii?Q?liAgqtWCS98yMgwNB8XKXCa2EWsUifta9yDiiGpqy2G7yeH4aoZGFsf04L6O?=
 =?us-ascii?Q?iPDcFg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a790898f-2ec8-463f-3dc0-08da004b5aa8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 15:01:27.4868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UjWK/F6sROiJEXQUOU6TRAnQMxXsqg9czn6a4AF3iOMRRrzhwWtM+yb68NNSa/ELQMga9NSOgJl/ugDx/4aSzJoYDeZK1PeFGaYPs8ke5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3162
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070088
X-Proofpoint-ORIG-GUID: fjWplAebQ6s5baA-c6tMuaOl9h85GlXo
X-Proofpoint-GUID: fjWplAebQ6s5baA-c6tMuaOl9h85GlXo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updating this API is risky because some places rely on the old behavior
and not all of them have been updated.  Here are some additional places
you might want to change.

drivers/usb/host/uhci-q.c:466 link_async() warn: iterator used outside loop: 'pqh'
drivers/infiniband/core/mad.c:968 ib_get_rmpp_segment() warn: iterator used outside loop: 'mad_send_wr->cur_seg'
drivers/opp/debugfs.c:208 opp_migrate_dentry() warn: iterator used outside loop: 'new_dev'
drivers/staging/greybus/audio_codec.c:602 gbcodec_mute_stream() warn: iterator used outside loop: 'module'
drivers/staging/media/atomisp/pci/atomisp_acc.c:508 atomisp_acc_load_extensions() warn: iterator used outside loop: 'acc_fw'
drivers/perf/thunderx2_pmu.c:814 tx2_uncore_pmu_init_dev() warn: iterator used outside loop: 'rentry'
drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c:111 nvkm_control_mthd_pstate_attr() warn: iterator used outside loop: 'pstate'
drivers/gpu/drm/panfrost/panfrost_mmu.c:203 panfrost_mmu_as_get() warn: iterator used outside loop: 'lru_mmu'
drivers/media/usb/uvc/uvc_v4l2.c:885 uvc_ioctl_enum_input() warn: iterator used outside loop: 'iterm'
drivers/media/usb/uvc/uvc_v4l2.c:896 uvc_ioctl_enum_input() warn: iterator used outside loop: 'iterm'
drivers/scsi/dc395x.c:3596 device_alloc() warn: iterator used outside loop: 'p'
drivers/net/ethernet/mellanox/mlx4/alloc.c:379 __mlx4_alloc_from_zone() warn: iterator used outside loop: 'curr_node'
fs/ocfs2/dlm/dlmdebug.c:573 lockres_seq_start() warn: iterator used outside loop: 'res'

This patchset fixes 3 bugs.  Initially when it's merged it's probably
going to introduce some bugs because there are likely other places which
rely on the old behavior.

In an ideal world, with the new API the compiler would warn about
uninitialized variables, but unfortunately that warning is disabled by
default so we still have to rely on kbuild/Clang/Smatch to find the
bugs.

But hopefully the new API encourages people to write clearer code so it
prevents bugs in the long run.

regards,
dan carpenter

