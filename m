Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA42199BF7
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbgCaQo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:44:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50099 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730442AbgCaQo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 12:44:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F0C65C0397;
        Tue, 31 Mar 2020 12:44:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 31 Mar 2020 12:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=+z62aXHMVsie2rw1NjMsXR8IK32
        XeBZupuwxskbGWNs=; b=o1MvH1FRka3xxtt7Ii4J+i1hu2dcGz49gu7MzvYv95p
        VfcvbTN7YBY4OpH8nBYV01ehBIAeHN9dX2X/CF1uqATT9ZiyVOZPtB4oOMKCE7z8
        3d79qbzGBTCkt8oJC1Zo6TJsEVnKB9K2EEMEEtzRKN3FwU/nWgdwQm6zjvzUUBvn
        KTs6avEcKXfQ79OujszLfiOJqR4lzeA2k+YgwhcURPW/tL7yHLIV9q6yDM1ZLi14
        s3dmOXJwSX+90Li7f0JfRp4c6cvN9yAV5g8FILEglnMnxqLy9wCkVvwAd3BQkIG/
        Mu5NraLlM9jPym5+xTdTnHK++OQ8OztfV4wQurbMs/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+z62aX
        HMVsie2rw1NjMsXR8IK32XeBZupuwxskbGWNs=; b=GIJAXGMDUuSeNVgfvqFpp1
        q0edvoFTTvQeUopS4kZ9O0FoNbXxejivoUHh5qMf00hJ2mK8dlk63rE8zAixwgr8
        yiHQEEyjCOFTHsu5VBa3+BLJbeRFsZn3xxCfVVjtHJdSz7Lq7Dy2C14Bgnq0eB0d
        6HH+AQdbyDktiL/4I1P3zRz+dUJ1WhPjCwfUrQSz83wG72PpH5aW1JlvWtJqOksE
        araVxLRSZ6vJ/uLO85wXMxabLpY8whGNha3AsnZNS2ehEOUCwthzo46C9LlJLhhf
        HTHyon/EJ+XfwcZbjBfKxAoYNYZZb21ctm8IdMxLuWLj2m8P5IfVPjKFYtDcOmvA
        ==
X-ME-Sender: <xms:h3ODXodfBpnj1wWm2AbuvT_Uz9Q5mmjGnWL_v8oloOPLHI2Su6lC3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtddtgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:h3ODXvUMoo10qGjVc_wPa8AgmIb_lHEvHzxD6PZzpQn7fPOW0j9LAQ>
    <xmx:h3ODXgysMJ0GdSqQG131oaEF7zpY5J3O3XictecMRyQMQ4ZZPqsLUw>
    <xmx:h3ODXljqCanyc1eQC8-Eqzjn95ObvwNmQSNwuEKzE8_tQisaSLjpWw>
    <xmx:iHODXvk_gqzekwhUO4e8rqC2uT8M6O7U6Gc1IXllCQDzk2htFvWL7g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 31489306CBA9;
        Tue, 31 Mar 2020 12:44:55 -0400 (EDT)
Date:   Tue, 31 Mar 2020 18:44:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the spdx tree
Message-ID: <20200331164448.GB1821785@kroah.com>
References: <20200331112334.213ea512@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331112334.213ea512@canb.auug.org.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 11:23:34AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   tools/testing/selftests/networking/timestamping/.gitignore
> 
> between commit:
> 
>   d198b34f3855 (".gitignore: add SPDX License Identifier")
> 
> from the spdx tree and commit:
> 
>   5ef5c90e3cb3 ("selftests: move timestamping selftests to net folder")
> 
> from the net-next tree.
> 
> I fixed it up (I just deleted the file) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.

That merge is fine, thanks,

greg k-h
