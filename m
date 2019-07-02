Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99375D6B6
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfGBTQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:16:10 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38530 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBTQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:16:10 -0400
Received: by mail-qk1-f194.google.com with SMTP id a27so15252538qkk.5;
        Tue, 02 Jul 2019 12:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KdQlWwq18gQWHWZt6kamX0qBRHEYO+CoFsjDTzbWUFM=;
        b=IPW4tI/icRbtvpabnj4518VO8QQMAizuKxoEyMHxl68aAobFe5gy5z/REgiG28pPMS
         GI3oKBpxVNzl2minXR7EHVYhdoKrqsF1Id3yEeM2mnRNOl+hQFlWMLl/FZm1PZmx2Fn9
         AOQ1UFXd3TjfkmcmBxRWFKQAtwLtUDcPu/ke0VUiJjC7Z+WIss8fo7x87bRZWoT3X7a4
         Fn2AMb6oyFOWMeKnevWpmyLUv8ac9RaOszE49lcCt0w+ywb4U1fBsHwV3xFSZBFUF8RP
         YQJ9vsoeXPvr81bgfhy+OuyoKeEcMOyiOKo1JmASxVytRIC24IR4yVBz4PSfiq4k4krK
         WVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KdQlWwq18gQWHWZt6kamX0qBRHEYO+CoFsjDTzbWUFM=;
        b=CdUzOeT7EU/VOUViCFx/AyZyDeJdXE64gHptFctU2A/uIBSqMdjxRFN2LqfiCnEh4p
         3qdeN27wAezRZRX5dUlWLSaeE2gGidnK79RCLn50vEWJ2pWGmxDFXo2t1fDdsx/9HSJb
         9lJt48yKOx4erMCpW95ieSbVdH9nu9tKl93LRFoiVpoodEKz+LKMhkTXiMdtZwZmas9f
         KYxBkuJmSJr28n/GNvQYKasn3lhTk/lmPyG3o8h8/c322yoYpme8GjXPvQ2bBFyQV+DN
         jlyknxR0ArfiYXYev2+uTfPVzh0wNFjH9BdpAayISjaIu4U6965ygkN+MShSqlr22Rha
         wTIQ==
X-Gm-Message-State: APjAAAU/QKGol7Bu0mO2ITfsLNdWz6aQV+GAZDkcqFzLtM2hJaZ63Gn+
        VNS5lKMU1ejAJfTexygOmFI=
X-Google-Smtp-Source: APXvYqzkBUBBRlBT0uTozV8Xn+x2dXepAqUqf2OrFCx39vpxK49HRGzhLVAsnXzu5hcxGFvBYjbxhg==
X-Received: by 2002:a37:8c7:: with SMTP id 190mr26911201qki.402.1562094969191;
        Tue, 02 Jul 2019 12:16:09 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:e50b:588:eb5f:c367:6d34])
        by smtp.gmail.com with ESMTPSA id d199sm6849421qkg.116.2019.07.02.12.16.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:16:08 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 286E7C0D87; Tue,  2 Jul 2019 16:16:06 -0300 (-03)
Date:   Tue, 2 Jul 2019 16:16:06 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, cphealy@gmail.com
Subject: Re: [PATCH net-next 07/12] net: use tcf_block_setup() infrastructure
Message-ID: <20190702191606.GC2746@localhost.localdomain>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-8-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194917.2298-8-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 09:49:12PM +0200, Pablo Neira Ayuso wrote:
...
> @@ -1173,8 +1191,10 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
>  	struct tc_block_offload bo = {};
>  	int err;
>  
> +	bo.net = dev_net(dev);
>  	bo.command = command;
>  	bo.binder_type = ei->binder_type;
> +	bo.net = dev_net(dev),
                             ^
And it's assigning the same thing twice in this chunk.

>  	bo.block = block;
>  	bo.extack = extack;
>  	INIT_LIST_HEAD(&bo.cb_list);
> -- 
> 2.11.0
> 
