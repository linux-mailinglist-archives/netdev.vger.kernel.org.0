Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A17412EA2
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 08:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhIUGc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 02:32:58 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45167 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229624AbhIUGc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 02:32:57 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id E1A0A580580;
        Tue, 21 Sep 2021 02:31:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 21 Sep 2021 02:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=oTBGFMPyU4+Tf7RPupYVb+Lp4bK
        j9jSmxX0YWXa5TG4=; b=OzTGP9m2MvAVw6Vt/2k6tJOYYqoH4fhOEZ8/UOcsopm
        QMDJH0RV4d66+8+BJ3TxAfkKU4YGHTCeKeaHy7SYT2fntqsuWeKYLLcnrWoCVV1D
        0Y5jyLsCbc5K2cSdth0Qq0e+eYU/G8vFIt1znEt0oq3lOBQO41nXRPhP3lMDy7Hr
        C1/nJkXk6zzghsIsXoAxj8IRvnMrebS9rR1rdAyYW9M678Y83gfjrw+gVc9SRXNA
        xsDPWo4tMvDOzqhTlJmRLJhY6fGAE1DbWg7kUv5wHOxTn2uczTFj+TujgAeUf73h
        MVx+4FWPpEoRRgOPYGb7jkyhFOt4MoVAAIRLeNlkkGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oTBGFM
        PyU4+Tf7RPupYVb+Lp4bKj9jSmxX0YWXa5TG4=; b=F0miU0vrS9ow+nWQxMwSY5
        gfRhIY+nIFx51KY4p0emYK8tgWfvSp8DSFojvG2CbVil3zokdxolKewVDwotzWIG
        N7CqgNKobiOLVGBc2J87yovI1lmJgi866+hywQZieDPx6/7525rihLRg6HYwMsB1
        DXqJ7acuHXwjB+XC9kBSAOs2nvTpiDrhKKJNP2hMeCdM9dWvzDimvDpAyckvqzkk
        ZlIBmO8zlQPt7MRJpy71E3OR1dLzvHe5f0OyRZHPbEEyZ1j+3dA7M2SOVcTpj87g
        0GwRhW+fYEs2STOLl58DboaBr4B6admYiiGoWam6i8QxwNeC6gvQ9pzPadP+9Zsw
        ==
X-ME-Sender: <xms:QHxJYZnNkcUOZ9l4oLLTpCwk4m50PSpPcL6qtoG5G8a94YLkYZpx2g>
    <xme:QHxJYU0czpyNrpWyfgOwWOmH1RRqQxUAZPl72P9PZf6rYMOP-0xx2f_EZo64v-0M5
    npME8N-LoIhyQ>
X-ME-Received: <xmr:QHxJYfqSi8WPLcQtmKL1MckWuz-rnb4fGimXWDDfZXZArFhD-OF6cQS15aYuEr8yLy-eIVaP9myHYxCjRMZIFGXDpxdro5DQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeifedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeeuleeltdehkeeltefhleduuddvhfffuedvffduveeghe
    ekgeeiffevheegfeetgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:QHxJYZmc1RFhEY3dZtNUOrFHJe6rT_JChN9o6-jlva0zBJxiD4nLkQ>
    <xmx:QHxJYX3n9MlpnBxWHdPop19SvbEV_yUaoaqWIjjkuTHN2bKjNZhLVg>
    <xmx:QHxJYYt6Y1NYJzuOp_9Gp0QPWD-lhD4QNG1_-mF6lHgBCqKzVp-Xlg>
    <xmx:QHxJYet6AqmOPpwR5oNO8y1yvH5nmU9VlDEtmYjQ0izhXKck0fiEyA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Sep 2021 02:31:27 -0400 (EDT)
Date:   Tue, 21 Sep 2021 08:31:24 +0200
From:   Greg KH <greg@kroah.com>
To:     Patrick.Mclean@sony.com
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        ayal@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        leonro@nvidia.com, Aaron.U'ren@sony.com, Russell.Brown@sony.com,
        Victor.Payno@sony.com
Subject: Re: mlx5_core 5.10 stable series regression starting at 5.10.65
Message-ID: <YUl8PKVz/em51KHR@kroah.com>
References: <BY5PR13MB3604D3031E984CA34A57B7C9EEA09@BY5PR13MB3604.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR13MB3604D3031E984CA34A57B7C9EEA09@BY5PR13MB3604.namprd13.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 08:22:44PM +0000, Patrick.Mclean@sony.com wrote:
> In 5.10 stable kernels since 5.10.65 certain mlx5 cards are no longer usable (relevant dmesg logs and lspci output are pasted below).
> 
> Bisecting the problem tracks the problem down to this commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=fe6322774ca28669868a7e231e173e09f7422118
> 
> Here is how lscpi -nn identifies the cards:
> 41:00.0 Ethernet controller [0200]: Mellanox Technologies MT27800 Family [ConnectX-5] [15b3:1017]
> 41:00.1 Ethernet controller [0200]: Mellanox Technologies MT27800 Family [ConnectX-5] [15b3:1017]
> 
> Here are the relevant dmesg logs:
> [   13.409473] mlx5_core 0000:41:00.0: firmware version: 16.31.1014
> [   13.415944] mlx5_core 0000:41:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
> [   13.707425] mlx5_core 0000:41:00.0: Rate limit: 127 rates are supported, range: 0Mbps to 24414Mbps
> [   13.718221] mlx5_core 0000:41:00.0: E-Switch: Total vports 2, per vport: max uc(128) max mc(2048)
> [   13.740607] mlx5_core 0000:41:00.0: Port module event: module 0, Cable plugged
> [   13.759857] mlx5_core 0000:41:00.0: mlx5_pcie_event:294:(pid 586): PCIe slot advertised sufficient power (75W).
> [   17.986973] mlx5_core 0000:41:00.0: E-Switch: cleanup
> [   18.686204] mlx5_core 0000:41:00.0: init_one:1371:(pid 803): mlx5_load_one failed with error code -22
> [   18.701352] mlx5_core: probe of 0000:41:00.0 failed with error -22
> [   18.727364] mlx5_core 0000:41:00.1: firmware version: 16.31.1014
> [   18.743853] mlx5_core 0000:41:00.1: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
> [   19.015349] mlx5_core 0000:41:00.1: Rate limit: 127 rates are supported, range: 0Mbps to 24414Mbps
> [   19.025157] mlx5_core 0000:41:00.1: E-Switch: Total vports 2, per vport: max uc(128) max mc(2048)
> [   19.053569] mlx5_core 0000:41:00.1: Port module event: module 1, Cable unplugged
> [   19.062093] mlx5_core 0000:41:00.1: mlx5_pcie_event:294:(pid 591): PCIe slot advertised sufficient power (75W).
> [   22.826932] mlx5_core 0000:41:00.1: E-Switch: cleanup
> [   23.544747] mlx5_core 0000:41:00.1: init_one:1371:(pid 803): mlx5_load_one failed with error code -22
> [   23.555071] mlx5_core: probe of 0000:41:00.1 failed with error -22
> 
> Please let me know if I can provide any further information.

If you revert that single change, do things work properly?

Does newer kernels (5.14, 5.15-rc2) work properly for you as well?

thanks,

greg k-h
