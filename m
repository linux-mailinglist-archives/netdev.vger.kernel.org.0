Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE213FEB53
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343647AbhIBJbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 05:31:16 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:57903 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343566AbhIBJbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 05:31:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id B326B2B0094C;
        Thu,  2 Sep 2021 05:30:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 02 Sep 2021 05:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=3Ndoi/9DZtcSDa4D0wet7sByYNJ
        CpnLWebIegCkqHM4=; b=qzWDblwvRoAKlFBrvxHgO+n7I1f0pni08r5bxXKV/Y5
        SZwGN/yoHIA5z1DpExHKFoDXVbX0wN2HmPXaDeMKTV+ruhLi//9crw0X9pMA9QDZ
        I7K8D5u70O7DGodk5CVoP2W+7h3hg8/84nVMbJsVc29CFYJIbo893FmAPZYfOgE1
        anyXEEyhzoW8Y6L9RGrT/SIO4TmutOQTLTv9F2oJKxJkDkr/NaB2fX7KhTqVxjgo
        jSJe0qfwr2i9QNjVrmTZbcJT5LdcyKPuxOwxmaKwnDd1NDbkYcvgS/ofBHDZ49N6
        Vj3vwnEdZDpu46nq1n7rGLD4HT952inxFcAktvCUSLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3Ndoi/
        9DZtcSDa4D0wet7sByYNJCpnLWebIegCkqHM4=; b=YopbxvnFQKGn6bYlDB4xiX
        Y2aVDw1oM5Oi/oAlxaooN6+x0g+Mx1agO2RT/1nL45U42Ro9NWcROoV+fCR1Jf21
        MSDh9L37vIdbGSvzWnr6ydpxKRO3uob/0NcFFF9iCGUNfA/BOXkcR+HJrXt+CtVE
        78HE18WESS03jwruY0fRDcKHb0in9RaQPcNIjexSULnTCSi+3hjqOtDyKNYcOCJm
        JtricD9/Zqah/RfN/blCDWn+Dwg/CyKVcsJ+AUARUg5RlYAZSvqSMIUaOE4H9NPi
        eLSbgLEUiJ8eLIGM5VWaoaYdJuPHOsw20gT2hCNq/R8BydF+WeSY3KA1cqQAIuIw
        ==
X-ME-Sender: <xms:p5kwYacQSfDEqnOv5afvEt9WNVA9RKdS0iAh5mYm1LO8G-LtpfTDSQ>
    <xme:p5kwYUM9_GfNuU1g0UEo-7ICIrayFVIQUn9O8XT2AwRjsix3lUbIGxKEUUArjQbFt
    -EW0DISFxvNsQ>
X-ME-Received: <xmr:p5kwYbiflHAjZi8it90HI7DftoMF7bGgKDnFhenMfHySU6ldFb87o3sGAASOEB0u1ZgOMHQgGsT4U2U5xz9bho9I6rUfcqSB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvhedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:p5kwYX-9SoljJ7IIuf8MneYRQp1nw3GkO2t1qNG0HLe9FF6MQ14d1g>
    <xmx:p5kwYWuNaqpUcQjFssg_R3pbScDB6S38PAsDu3TV0xWH84rq2Jd2hg>
    <xmx:p5kwYeH09vMuvR8ep1v-nRO-KMFDsFTFmWipeWSDqvS1DpAizmbXWA>
    <xmx:qJkwYWHim_AfYCh-5W1DV29hlwW06LxIfsKp2k-gI18pKioj8t1_DJLdkaA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Sep 2021 05:30:14 -0400 (EDT)
Date:   Thu, 2 Sep 2021 11:30:04 +0200
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Phillip Potter <phil@philpotter.co.uk>
Subject: Re: linux-next: manual merge of the net-next tree with the
 iio-fixes, staging trees
Message-ID: <YTCZnBBnG6HcI5TB@kroah.com>
References: <20210830154618.204ac5c8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830154618.204ac5c8@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 03:46:18PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got conflicts in:
> 
>   drivers/staging/rtl8188eu/include/osdep_intf.h
>   drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
>   drivers/staging/rtl8188eu/os_dep/os_intfs.c
> 
> between commit:
> 
>   55dfa29b43d2 ("staging: rtl8188eu: remove rtl8188eu driver from staging dir")
> 
> from the iio-fixes, staging trees and commit:
> 
>   89939e890605 ("staging: rtlwifi: use siocdevprivate")
> 
> from the net-next tree.
> 
> I fixed it up (I have removed these files) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell



Should all now be resolved in Linus's tree.

thanks,

greg k-h
