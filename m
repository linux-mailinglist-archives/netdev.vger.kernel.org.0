Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F493C63CE
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 21:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbhGLTfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 15:35:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236457AbhGLTfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 15:35:46 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CJ3Ta0173460;
        Mon, 12 Jul 2021 15:32:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=QvtW3FBa9tE1mwfOAdgXsMj45z9JyERAMcNsH2N1onA=;
 b=LvSdQUvsVa+CwHlDDoHFhzeCqQg2WB318Jr44xnCAAg3YPb5bx3nfgZNSAqdrcCprNsk
 54MaC7pkhex8ad0pdh0YKRBsWafXgfEjhvvFsVBweA3AHewrl6FLm0qM3uQqoFFdRArT
 5Iu/L5KGSaDJIrVkHf6uNBfyzW+kQ7hH53PFGe+vZ99Ralg8ggk1JGcmj5Bn+UY4ap7j
 CxTjt16MelCNb8DUlFrlgcAHeW4hHy2a0npdtpZQmZDGXWU9xgT+D6CkCHlI6gfmHKfA
 8XvWn+4XDPZ0mZaJCyi6kNFRcxJcftbP0s4uRZ5GH5RHujETvoE0JspovH/K6Xgol196 oA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39qs65c008-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 15:32:46 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16CJWNtD013401;
        Mon, 12 Jul 2021 19:32:45 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 39q36addyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 19:32:45 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16CJWiM113566422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 19:32:44 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E6EBBE059;
        Mon, 12 Jul 2021 19:32:44 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F653BE054;
        Mon, 12 Jul 2021 19:32:44 +0000 (GMT)
Received: from v0005c16 (unknown [9.211.69.66])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 12 Jul 2021 19:32:43 +0000 (GMT)
Message-ID: <84e7fbd7e65a6ee363763d8155c47d74ed24f9e0.camel@linux.ibm.com>
Subject: Re: [PATCH v2 2/3] net/ncsi: add NCSI Intel OEM command to keep PHY
 up
From:   Eddie James <eajames@linux.ibm.com>
To:     Joel Stanley <joel@jms.id.au>,
        Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     Networking <netdev@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>
Date:   Mon, 12 Jul 2021 14:32:43 -0500
In-Reply-To: <CACPK8Xff9c-_9A_tfZ4UBjucUgRmy8iOOdzcV5dg8VUCOB29AQ@mail.gmail.com>
References: <20210708122754.555846-1-i.mikhaylov@yadro.com>
         <20210708122754.555846-3-i.mikhaylov@yadro.com>
         <CACPK8Xff9c-_9A_tfZ4UBjucUgRmy8iOOdzcV5dg8VUCOB29AQ@mail.gmail.com>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ULXN2HCrschaqxdNXlTeVKiKBPTP-wVY
X-Proofpoint-GUID: ULXN2HCrschaqxdNXlTeVKiKBPTP-wVY
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_10:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1011 impostorscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-12 at 10:01 +0000, Joel Stanley wrote:
> On Thu, 8 Jul 2021 at 12:27, Ivan Mikhaylov <i.mikhaylov@yadro.com>
> wrote:
> > This allows to keep PHY link up and prevents any channel resets
> > during
> > the host load.
> > 
> > It is KEEP_PHY_LINK_UP option(Veto bit) in i210 datasheet which
> > block PHY reset and power state changes.
> 
> How about using runtime configuration over using kconfig for this, so
> the same kernel config can be used on different machines. Something
> device tree based?
> 
> Another option is to use the netlink handler to send the OEM command
> from userspace. Eddie has worked on this for an IBM machine, and I've
> asked him to post those changes. I would prefer the kernel option
> though.

For reference that is here: 
https://gerrit.openbmc-project.xyz/c/openbmc/phosphor-networkd/+/36592

Thanks,
Eddie

> 
> 
> > Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
> > ---
> >  net/ncsi/Kconfig       |  6 ++++++
> >  net/ncsi/internal.h    |  5 +++++
> >  net/ncsi/ncsi-manage.c | 45
> > ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 56 insertions(+)
> > 
> > diff --git a/net/ncsi/Kconfig b/net/ncsi/Kconfig
> > index 93309081f5a4..ea1dd32b6b1f 100644
> > --- a/net/ncsi/Kconfig
> > +++ b/net/ncsi/Kconfig
> > @@ -17,3 +17,9 @@ config NCSI_OEM_CMD_GET_MAC
> >         help
> >           This allows to get MAC address from NCSI firmware and set
> > them back to
> >                 controller.
> > +config NCSI_OEM_CMD_KEEP_PHY
> > +       bool "Keep PHY Link up"
> > +       depends on NET_NCSI
> > +       help
> > +         This allows to keep PHY link up and prevents any channel
> > resets during
> > +         the host load.
> > diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
> > index cbbb0de4750a..0b6cfd3b31e0 100644
> > --- a/net/ncsi/internal.h
> > +++ b/net/ncsi/internal.h
> > @@ -78,6 +78,9 @@ enum {
> >  /* OEM Vendor Manufacture ID */
> >  #define NCSI_OEM_MFR_MLX_ID             0x8119
> >  #define NCSI_OEM_MFR_BCM_ID             0x113d
> > +#define NCSI_OEM_MFR_INTEL_ID           0x157
> > +/* Intel specific OEM command */
> > +#define NCSI_OEM_INTEL_CMD_KEEP_PHY     0x20   /* CMD ID for Keep
> > PHY up */
> >  /* Broadcom specific OEM Command */
> >  #define NCSI_OEM_BCM_CMD_GMA            0x01   /* CMD ID for Get
> > MAC */
> >  /* Mellanox specific OEM Command */
> > @@ -86,6 +89,7 @@ enum {
> >  #define NCSI_OEM_MLX_CMD_SMAF           0x01   /* CMD ID for Set
> > MC Affinity */
> >  #define NCSI_OEM_MLX_CMD_SMAF_PARAM     0x07   /* Parameter for
> > SMAF         */
> >  /* OEM Command payload lengths*/
> > +#define NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN 7
> >  #define NCSI_OEM_BCM_CMD_GMA_LEN        12
> >  #define NCSI_OEM_MLX_CMD_GMA_LEN        8
> >  #define NCSI_OEM_MLX_CMD_SMAF_LEN        60
> > @@ -271,6 +275,7 @@ enum {
> >         ncsi_dev_state_probe_mlx_gma,
> >         ncsi_dev_state_probe_mlx_smaf,
> >         ncsi_dev_state_probe_cis,
> > +       ncsi_dev_state_probe_keep_phy,
> >         ncsi_dev_state_probe_gvi,
> >         ncsi_dev_state_probe_gc,
> >         ncsi_dev_state_probe_gls,
> > diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
> > index 42b54a3da2e6..89c7742cd72e 100644
> > --- a/net/ncsi/ncsi-manage.c
> > +++ b/net/ncsi/ncsi-manage.c
> > @@ -689,6 +689,35 @@ static int set_one_vid(struct ncsi_dev_priv
> > *ndp, struct ncsi_channel *nc,
> >         return 0;
> >  }
> > 
> > +#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
> > +
> > +static int ncsi_oem_keep_phy_intel(struct ncsi_cmd_arg *nca)
> > +{
> > +       unsigned char data[NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN];
> > +       int ret = 0;
> > +
> > +       nca->payload = NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN;
> > +
> > +       memset(data, 0, NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN);
> > +       *(unsigned int *)data = ntohl((__force
> > __be32)NCSI_OEM_MFR_INTEL_ID);
> > +
> > +       data[4] = NCSI_OEM_INTEL_CMD_KEEP_PHY;
> > +
> > +       /* PHY Link up attribute */
> > +       data[6] = 0x1;
> > +
> > +       nca->data = data;
> > +
> > +       ret = ncsi_xmit_cmd(nca);
> > +       if (ret)
> > +               netdev_err(nca->ndp->ndev.dev,
> > +                          "NCSI: Failed to transmit cmd 0x%x
> > during configure\n",
> > +                          nca->type);
> > +       return ret;
> > +}
> > +
> > +#endif
> > +
> >  #if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
> > 
> >  /* NCSI OEM Command APIs */
> > @@ -1391,8 +1420,24 @@ static void ncsi_probe_channel(struct
> > ncsi_dev_priv *ndp)
> >                                 goto error;
> >                 }
> > 
> > +               nd->state = ncsi_dev_state_probe_gvi;
> > +               if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
> > +                       nd->state = ncsi_dev_state_probe_keep_phy;
> > +               break;
> > +#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
> > +       case ncsi_dev_state_probe_keep_phy:
> > +               ndp->pending_req_num = 1;
> > +
> > +               nca.type = NCSI_PKT_CMD_OEM;
> > +               nca.package = ndp->active_package->id;
> > +               nca.channel = 0;
> > +               ret = ncsi_oem_keep_phy_intel(&nca);
> > +               if (ret)
> > +                       goto error;
> > +
> >                 nd->state = ncsi_dev_state_probe_gvi;
> >                 break;
> > +#endif /* CONFIG_NCSI_OEM_CMD_KEEP_PHY */
> >         case ncsi_dev_state_probe_gvi:
> >         case ncsi_dev_state_probe_gc:
> >         case ncsi_dev_state_probe_gls:
> > --
> > 2.31.1
> > 

