Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC182C4042
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 13:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgKYMeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 07:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgKYMeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 07:34:01 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4C7C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 04:34:01 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id r18so2124705ljc.2
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 04:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EVe5POv3aa7dU3vUuog57QbOZrixAdov9pVP3eydeoo=;
        b=Ck94bbY1W+pkNSnAX3vx03SXp8N3MtZaykkN05t2hLTXxMwTHVH4sB/LxBHLH6AZS9
         oQL/18hH9tVyHJFtmvkP8+oVmZBB4cPa53+dxZoN/wSanLjll1mtJcCYJTPg4Gm8N80X
         Y2vZkB8MjfJfWO03ZJeN+/xkyVeFKAXdF/T3ypAMmqCrggPdhYj8AP/GHfeeyLqSqQ2k
         D/3XFKnUgghljTkJNB6obDycku6SGRsG8Ou9eRBgYGhRwmSQnUSLSa9ubJQwqbUhgnyB
         KKTUnxUcjrtGjrprY1dJQyzJGhMpUt6+i4kh1UNl8reZoMiCHpERnM2MUOdieZP2oHU1
         f/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EVe5POv3aa7dU3vUuog57QbOZrixAdov9pVP3eydeoo=;
        b=cvCTtKPs45yxaRODKaTPZF18gYUw3xgaDYjJzqTg4XmV6L0x1pEtxUO8grkBbbFnWn
         BEtxXO2Y9C+eUxeOeNsVBOcO2FLqlHfnpexEkIatXnIlNmG1K9SgaiSZo7Fsj7el3t29
         VjVShDBY2k9gHuULGhXh+kgZTpB7yeL7snGlRxyMhNuhCXqRRIINt/akhlt/hsLAK4Q1
         7IgPgFQAYzltkfNlfmuj9dk+TIT13mNXCEhq33niWo6Lx3GutsuCB2hlsZLNztG6aHel
         wO5KoEhi8TE6nTiD+PlfKhAWpF90hYNozZULr223IsqYND7uPlNnmFVOfKcEEKfKhtxM
         HEyw==
X-Gm-Message-State: AOAM5306JzVFNK5ftzehlOZxZg8mcKS/Mwe+mGkUweFVSqw9rowDIsEv
        DWzEDePkf6qixYXTzQB7U11bQVpCT4BGGPWgEyg=
X-Google-Smtp-Source: ABdhPJzOriSnYKwSvxwLxgmL/BdKHWLv0aU/RWxvb68hF8AtjeQzog70BmohNuchgsRmSD0LtBU9eWGSO1YzEeKTzFM=
X-Received: by 2002:a2e:9346:: with SMTP id m6mr1022377ljh.195.1606307639998;
 Wed, 25 Nov 2020 04:33:59 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201123101208epcms2p71d4c8d66f08fb7a2e10ae422abde3389@epcms2p7>
 <20201123101208epcms2p71d4c8d66f08fb7a2e10ae422abde3389@epcms2p7> <20201124144353.7c759cae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124144353.7c759cae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Wed, 25 Nov 2020 21:33:48 +0900
Message-ID: <CACwDmQAZ48JrM3AuiKwuSdhcpfo_d2_P0B+mtd4Mshfa3WUVpA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/nfc/nci: Support NCI 2.x initial sequence
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-nfc@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 9:03 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 23 Nov 2020 19:12:08 +0900 Bongsu Jeon wrote:
> > implement the NCI 2.x initial sequence to support NCI 2.x NFCC.
> > Since NCI 2.0, CORE_RESET and CORE_INIT sequence have been changed.
> > If NFCEE supports NCI 2.x, then NCI 2.x initial sequence will work.
> >
> > In NCI 1.0, Initial sequence and payloads are as below:
> > (DH)                     (NFCC)
> >  |  -- CORE_RESET_CMD --> |
> >  |  <-- CORE_RESET_RSP -- |
> >  |  -- CORE_INIT_CMD -->  |
> >  |  <-- CORE_INIT_RSP --  |
> >  CORE_RESET_RSP payloads are Status, NCI version, Configuration Status.
> >  CORE_INIT_CMD payloads are empty.
> >  CORE_INIT_RSP payloads are Status, NFCC Features,
> >     Number of Supported RF Interfaces, Supported RF Interface,
> >     Max Logical Connections, Max Routing table Size,
> >     Max Control Packet Payload Size, Max Size for Large Parameters,
> >     Manufacturer ID, Manufacturer Specific Information.
> >
> > In NCI 2.0, Initial Sequence and Parameters are as below:
> > (DH)                     (NFCC)
> >  |  -- CORE_RESET_CMD --> |
> >  |  <-- CORE_RESET_RSP -- |
> >  |  <-- CORE_RESET_NTF -- |
> >  |  -- CORE_INIT_CMD -->  |
> >  |  <-- CORE_INIT_RSP --  |
> >  CORE_RESET_RSP payloads are Status.
> >  CORE_RESET_NTF payloads are Reset Trigger,
> >     Configuration Status, NCI Version, Manufacturer ID,
> >     Manufacturer Specific Information Length,
> >     Manufacturer Specific Information.
> >  CORE_INIT_CMD payloads are Feature1, Feature2.
> >  CORE_INIT_RSP payloads are Status, NFCC Features,
> >     Max Logical Connections, Max Routing Table Size,
> >     Max Control Packet Payload Size,
> >     Max Data Packet Payload Size of the Static HCI Connection,
> >     Number of Credits of the Static HCI Connection,
> >     Max NFC-V RF Frame Size, Number of Supported RF Interfaces,
> >     Supported RF Interfaces.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
>
> NFC folks, looks like when the NFC core got orphaned it lost all links
> in MAINTAINERS. Should we add the L: linux-nfc@lists.01.org so that
> there is a better chance that someone knowledgeable will provide
> reviews?
>
> Also if anyone is up for it feel free to add your M: or R: entries!
>

Okay. It's better. I will add linux-nfc@lists.01.org when I resend the
new version.

> >  #define NCI_OP_CORE_INIT_CMD         nci_opcode_pack(NCI_GID_CORE, 0x01)
> > +/* To support NCI 2.x */
> > +struct nci_core_init_v2_cmd {
> > +     unsigned char   feature1;
> > +     unsigned char   feature2;
> > +} __packed;
>
> No need for this to be packed.
>
> >  #define NCI_OP_CORE_SET_CONFIG_CMD   nci_opcode_pack(NCI_GID_CORE, 0x02)
> >  struct set_config_param {
> > @@ -316,6 +326,11 @@ struct nci_core_reset_rsp {
> >       __u8    config_status;
> >  } __packed;
> >
> > +/* To support NCI ver 2.x */
> > +struct nci_core_reset_rsp_nci_ver2 {
> > +     unsigned char   status;
> > +} __packed;
>
> ditto
>

Okay I will fix it.

> >  #define NCI_OP_CORE_INIT_RSP         nci_opcode_pack(NCI_GID_CORE, 0x01)
> >  struct nci_core_init_rsp_1 {
> >       __u8    status;
> > @@ -334,6 +349,20 @@ struct nci_core_init_rsp_2 {
> >       __le32  manufact_specific_info;
> >  } __packed;
> >
> > +/* To support NCI ver 2.x */
> > +struct nci_core_init_rsp_nci_ver2 {
> > +     unsigned char   status;
> > +     __le32  nfcc_features;
> > +     unsigned char   max_logical_connections;
> > +     __le16  max_routing_table_size;
> > +     unsigned char   max_ctrl_pkt_payload_len;
> > +     unsigned char   max_data_pkt_hci_payload_len;
> > +     unsigned char   number_of_hci_credit;
> > +     __le16  max_nfc_v_frame_size;
> > +     unsigned char   num_supported_rf_interfaces;
> > +     unsigned char   supported_rf_interfaces[];
> > +} __packed;
> > +
> >  #define NCI_OP_CORE_SET_CONFIG_RSP   nci_opcode_pack(NCI_GID_CORE, 0x02)
> >  struct nci_core_set_config_rsp {
> >       __u8    status;
> > @@ -372,6 +401,16 @@ struct nci_nfcee_discover_rsp {
> >  /* --------------------------- */
> >  /* ---- NCI Notifications ---- */
> >  /* --------------------------- */
> > +#define NCI_OP_CORE_RESET_NTF                nci_opcode_pack(NCI_GID_CORE, 0x00)
> > +struct nci_core_reset_ntf {
> > +     unsigned char   reset_trigger;
> > +     unsigned char   config_status;
> > +     unsigned char   nci_ver;
> > +     unsigned char   manufact_id;
> > +     unsigned char   manufacturer_specific_len;
> > +     __le32  manufact_specific_info;
> > +} __packed;
> > +
> >  #define NCI_OP_CORE_CONN_CREDITS_NTF nci_opcode_pack(NCI_GID_CORE, 0x06)
> >  struct conn_credit_entry {
> >       __u8    conn
> > diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> > index 4953ee5146e1..68889faadda2 100644
> > --- a/net/nfc/nci/core.c
> > +++ b/net/nfc/nci/core.c
> > @@ -165,7 +165,14 @@ static void nci_reset_req(struct nci_dev *ndev, unsigned long opt)
> >
> >  static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
> >  {
> > -     nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
> > +     struct nci_core_init_v2_cmd *cmd = (struct nci_core_init_v2_cmd *)opt;
> > +
> > +     if (!cmd) {
> > +             nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
> > +     } else {
> > +             /* if nci version is 2.0, then use the feature parameters */
> > +             nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, sizeof(struct nci_core_init_v2_cmd), cmd);
>
> Please wrap this line.
>

Sorry, Could you explain it in detail?

> > +     }
>
> Parenthesis unnecessary.
>

Ok. I will fix it.

> >  }
> >
> >  static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
>
> > +static unsigned char nci_core_init_rsp_packet_v2(struct nci_dev *ndev, struct sk_buff *skb)
> > +{
> > +     struct nci_core_init_rsp_nci_ver2 *rsp = (void *)skb->data;
> > +     unsigned char rf_interface_idx = 0;
> > +     unsigned char rf_extension_cnt = 0;
> > +     unsigned char *supported_rf_interface = rsp->supported_rf_interfaces;
> > +
> > +     pr_debug("status %x\n", rsp->status);
> > +
> > +     if (rsp->status != NCI_STATUS_OK)
> > +             return rsp->status;
> > +
> > +     ndev->nfcc_features = __le32_to_cpu(rsp->nfcc_features);
> > +     ndev->num_supported_rf_interfaces = rsp->num_supported_rf_interfaces;
> > +
> > +     if (ndev->num_supported_rf_interfaces >
> > +         NCI_MAX_SUPPORTED_RF_INTERFACES) {
> > +             ndev->num_supported_rf_interfaces =
> > +                     NCI_MAX_SUPPORTED_RF_INTERFACES;
> > +     }
>
> brackets unnecessary unnecessary
>
> also:
>
>         ndev->num_supported_rf_interfaces =
>                 min(ndev->num_supported_rf_interfaces,
>                     NCI_MAX_SUPPORTED_RF_INTERFACES);
>

Okay. I will fix it.
Thanks for reviewing this code.

> > +     while (rf_interface_idx < ndev->num_supported_rf_interfaces) {
> > +             ndev->supported_rf_interfaces[rf_interface_idx++] = *supported_rf_interface++;
> > +
> > +             /* skip rf extension parameters */
> > +             rf_extension_cnt = *supported_rf_interface++;
> > +             supported_rf_interface += rf_extension_cnt;
> > +     }
