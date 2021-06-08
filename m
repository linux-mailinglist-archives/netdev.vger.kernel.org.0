Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B19B39F14E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFHIsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:48:02 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:43025 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231337AbhFHIsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:48:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 79FBF5804C1;
        Tue,  8 Jun 2021 04:46:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 08 Jun 2021 04:46:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=O
        cJGuks2BsIJ9Z1Uvy/YBynhz/rsZ2UduAezquC86NI=; b=Av6caqxi5rTeJuJHw
        NWZllbrLTXvWa6MpjlijpjX11gb55Q9azwW9YidOA7pOaoaBZSbY9Er5dQF3lAwH
        XRCYFjQQkWNjX09zfqB2bbyTZ2mYtyx2iNJu1VVlM/KfyAN6Tnjugvlkl6cKwKrF
        v5Q4Stz39wCAJcxFC3HftStWE/BMDI9JOUeza2CR4jQFVcJlT+N3QezxzhJe2yIB
        S3QXGkKjZ7jcy1uCy+7X53oQC0v2UeKU+K61lSBBZrBzNm4bUcg9wC8QCa5ErgDI
        2c+8ZfMRSyHtP9PSb0qUczFUy5Fqcr7m9/I999kyu60xVMk94hj+0wYvV7Y1Yvfl
        dSSWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=OcJGuks2BsIJ9Z1Uvy/YBynhz/rsZ2UduAezquC86
        NI=; b=LQ3VVl0vrlrnC1fH8a6CIwcGKSaKfX0uKUPPrFAxMAoczlzylddAm1zFD
        rYqKAwYGUWA/3OAg2hMIW9NFlRfDq7MZTwuuEqBL226S/F/OSkbV31O/L3ZudGdN
        xIv+0nG+5SjqmHYHjrZXqM6E72EZ8DcfQig6lt4AVp+Yan/a2FE3fusNCm0/TnYE
        rEUdURyDrdJdZzWXpPKA7bHeyZoilks79sJa8CquafC8YfJHuVXf0ibgmvQLTr1i
        XC3auMTnQ6ebbQDZd0RxdXliO92ysTZJ3e/teU8uNtYzNWOtwuCxWbJvchXXkuG/
        bESeHmPi1hLl9C76I1WnQkySvf12Q==
X-ME-Sender: <xms:TS6_YIUQMV85vYceE_lEfts11O3sw_pzt-ANcNmNvDlGmb4-zWcgpQ>
    <xme:TS6_YMmiTXVRcc3dMiyofq3ut_wU-7FvwJ7wa7jYb8bZoSlbYoLjrMtumMsY2oU2Z
    lmyh9f1u44CKw>
X-ME-Received: <xmr:TS6_YMY9-whsuVEzWq1Bp1BSfff-rqAZsKkvlLrs-jk_6INBXZz8KoY_ZE7TZO3TWk_spwo0adZE16jkQr7Ag6vv3SjhsTPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:TS6_YHWd5HfNLAvh7lnUeqIL8D5jGoHawtStOpDi8ll8GN3zLPjDag>
    <xmx:TS6_YCnt7Uu46jz_WR3dWUz52tJNSV5gJXuTALwt-yUAhUW-zsoxqg>
    <xmx:TS6_YMdsE8gWbnV1WaLsXIEZv-twskMgkpCqAI_AQWZy05m4peZpYw>
    <xmx:Ty6_YEXRGZbV09VfuUGJhNrBV6JF7eva0271Y_yYabrH33rJJ0R8ng>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 04:46:05 -0400 (EDT)
Date:   Tue, 8 Jun 2021 10:46:04 +0200
From:   Greg KH <greg@kroah.com>
To:     SyzScope <syzscope@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        kernel-hardening@lists.openwall.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YL8uTH9Ey3U38yPr@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
 <YL3zGGMRwmD7fNK+@zx2c4.com>
 <YL4BAKHPZqH6iPdP@kroah.com>
 <dd3094fa-9cb8-91c2-7631-a69c34eac387@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd3094fa-9cb8-91c2-7631-a69c34eac387@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 11:26:26AM -0700, SyzScope wrote:
> Hi all,
> We are really thankful for all the suggestions and concerns. We are
> definitely interested in continuing this line of research.
> 
> Just to clarify:  SyzScope is an ongoing research project that is currently
> under submission, which has an anonymity requirement.

As documented, we can not accept anonymous contributions to the kernel,
so perhaps just wait until your paper is accepted?  However, we take
patches from researchers all the time under their real names while their
papers are being reviewed, so this "requirement" seems odd to me, who is
requiring this?

> Therefore we chose to
> use a gmail address initially in the public channel. Since Greg asked, we
> did reveal our university affiliation and email address, as well as
> cross-referenced a private email (again using university address) to
> security@kernel.org.

security@kernel.org is for fixing bugs reported to them that are not
public, it is not for any sort of "notification of affiliation".  See
the documentation for the details about what this alias is to be used
for please.

> We are sorry for the chaos of using several different
> email addresses. In the future, we will try to use our university address
> directly (we checked with other researchers and it seems to be okay).

That would be best, as obviously, and again, as documented, we can not
accept anonymous contributions to the kernel.

greg k-h
