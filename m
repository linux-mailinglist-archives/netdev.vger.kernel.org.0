Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5073028903C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbgJIRrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730673AbgJIRrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:47:20 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED7FC0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 10:47:20 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id l23so1252686vkm.1
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 10:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NrplCNhyYjIuAK++3rSBS/2tDTEQRphlqGjzusEVaew=;
        b=IzhGtF+a2KhIlKIEPEOIa6Qzaio0VWtdjmeg22Pqqaw54j+E9kaavom/B4EbUpYg3h
         In/6QexWxleZrNSV+/lXJNGd7e+kRW+0Kt1B9EA2I4qcV6v6+47YQ2CuRxvle5n77DQU
         Sx+akorqUBFB1jm+OT6KjD0ogBv6COBsJgxTnXUGC9/YRhWm6J31+yhOZsZ9r8JFN5YZ
         U+0bS4HFEw+2Nj/zn0Th/rnJjn9RkdExUJmFuRGXuE6sUYZWL7x+tdsfcpnOdW/Gy5XO
         QdILGDdYCpv9Dcy3r+TZ190eMWFWVVO9ThpRLNyLneIagmZgcAg3iekFzAZ6Ph4UkpGk
         l7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NrplCNhyYjIuAK++3rSBS/2tDTEQRphlqGjzusEVaew=;
        b=MUuKQPiiu98n+AM8Sftj+27WYaxAvKMBAOBXoAEE4LLEbyAbxW7Zatp5LYzpCrAp0w
         CAMtnHlJTdfAUp6qcHFLEhF2icef+CJZ8DtEbG5qEVTcAC8R/QZgkvN+btXieAC/gm+F
         D4wpEkFHopDCvlPfJPWvH+/u8cMh3a5+o6BpCH1HlCwjjy9yR9vEjpgB4yXv/a8ygeBF
         0vfldPvEIKoME9RpGIF6SAuEA9K+rZAQNtwmPEGsxOpF+3yHSWSgWAunxRmqgxYpDR7z
         cvTEUFqI6QWlKcVi7c3/Kl0wGP+laSY65ckINcYGeEA6W4YJxXSAnuhUJ3MCC4/v5w2Z
         cGQg==
X-Gm-Message-State: AOAM531qJ8BXwt9Gskin9YLmA4FvwUzTpjZl2QmWqh4iXeJa6GiXobpj
        Ux1GI1U9Kj3hQgpT4RrTuw0r97wENXU=
X-Google-Smtp-Source: ABdhPJwuMGrVUZktorEyoF++Joc9sPIxMqUfbnVm07FzBWApX7BRto/4b+milKqxz7f0vhvhyGgh2A==
X-Received: by 2002:a1f:8c0e:: with SMTP id o14mr8479044vkd.2.1602265638395;
        Fri, 09 Oct 2020 10:47:18 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id p130sm1249667vke.14.2020.10.09.10.47.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 10:47:17 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id r1so4378136vsi.12
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 10:47:17 -0700 (PDT)
X-Received: by 2002:a67:684e:: with SMTP id d75mr8802635vsc.28.1602265636761;
 Fri, 09 Oct 2020 10:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com> <20201007231050.1438704-3-anthony.l.nguyen@intel.com>
In-Reply-To: <20201007231050.1438704-3-anthony.l.nguyen@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 9 Oct 2020 13:46:39 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfX55yiPHZ-Pf051RqMkKbyvHWT86HFB135Tb4kjm6PjQ@mail.gmail.com>
Message-ID: <CA+FuTSfX55yiPHZ-Pf051RqMkKbyvHWT86HFB135Tb4kjm6PjQ@mail.gmail.com>
Subject: Re: [net-next 2/3] i40e: Fix MAC address setting for a VF via Host/VM
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        nhorman@redhat.com, sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 7:11 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>
> Fix MAC setting flow for the PF driver.
>
> Without this change the MAC address setting was interpreted
> incorrectly in the following use cases:
> 1) Print incorrect VF MAC or zero MAC
> ip link show dev $pf
> 2) Don't preserve MAC between driver reload
> rmmod iavf; modprobe iavf
> 3) Update VF MAC when macvlan was set
> ip link add link $vf address $mac $vf.1 type macvlan
> 4) Failed to update mac address when VF was trusted
> ip link set dev $vf address $mac
>
> This includes all other configurations including above commands.
>
> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

If this is a fix, should it target net and/or is there a commit for a Fixes tag?

> @@ -2740,6 +2744,7 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
>  {
>         struct virtchnl_ether_addr_list *al =
>             (struct virtchnl_ether_addr_list *)msg;
> +       bool was_unimac_deleted = false;
>         struct i40e_pf *pf = vf->pf;
>         struct i40e_vsi *vsi = NULL;
>         i40e_status ret = 0;
> @@ -2759,6 +2764,8 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
>                         ret = I40E_ERR_INVALID_MAC_ADDR;
>                         goto error_param;
>                 }
> +               if (ether_addr_equal(al->list[i].addr, vf->default_lan_addr.addr))
> +                       was_unimac_deleted = true;
>         }
>         vsi = pf->vsi[vf->lan_vsi_idx];
>
> @@ -2779,10 +2786,25 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
>                 dev_err(&pf->pdev->dev, "Unable to program VF %d MAC filters, error %d\n",
>                         vf->vf_id, ret);
>
> +       if (vf->trusted && was_unimac_deleted) {
> +               struct i40e_mac_filter *f;
> +               struct hlist_node *h;
> +               u8 *macaddr = NULL;
> +               int bkt;
> +
> +               /* set last unicast mac address as default */
> +               spin_lock_bh(&vsi->mac_filter_hash_lock);
> +               hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
> +                       if (is_valid_ether_addr(f->macaddr))
> +                               macaddr = f->macaddr;

nit: could break here
