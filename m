Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D4220600
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 09:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgGOHQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 03:16:21 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55417 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728883AbgGOHQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 03:16:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 123E25C003D;
        Wed, 15 Jul 2020 03:16:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Jul 2020 03:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=s
        cNPZaie3mZkWaCFW1bBIfFa4ifRY2lMsxABYKuY/Wo=; b=rIWaNGQ8oNEfWo6Vy
        Ow7QGW3GuZ5nt5VGDzDifFRccA5GZw6s3o0uuNfRmIkCzPE8b/cKbZe+lXoAJbS/
        9+UK9HbSg4L0BT4yzgkgGo6x5JiIoUaj2nGqNnIJBROlE0NIapK7iGIIxcqPQ+oh
        6ieYdeeRZGGBRuDPx0yYtgQ7RbURMUJbtFQmgrZDfxYcXxUlN5235ld/A3XrHi2+
        oVSBWhMH3qCvLtDpv1Z7r7wDYuud6opCiT0PJZ85mQz7LnLlk8HYzQfNl5xcWf5N
        kmj/1sJBJD9wXBnYivLrutN63l60jU54RxNZXiJ4sq/L7ddLHAejAQvNJhk+dc04
        ZTysg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=scNPZaie3mZkWaCFW1bBIfFa4ifRY2lMsxABYKuY/
        Wo=; b=nDjikQMx+OeNIPUIzwJ5EmhXXNr5sQ4X1Yq98QOMd12+QDEd10qFV7VYA
        pZ+OqV4COcAzgajUTZ22DOfeHs0/8n6eKtK9UhL3DJ2bSh2crDYhn6TQI/OGJkOZ
        6sL1bj1XTa7KbIpCCHded3YiqlU0vegCVdFnI1loUGA3bHsq1m+ZCOXG7IP6EBBy
        kkw4i/tB+ChCc3eMwm5ELfuf9FA6SdAHWdZ55fN1k05A8mtSe1aGIOuXRGNqtMqd
        /tdlURxsLxtzdQdjMWoH0t9qCvHUd0M/YvhAob/nqRTGi/F1qO09z/kko91M4aZT
        oiziXIhK5PGiSld2NSGO7Rk/8yzYQ==
X-ME-Sender: <xms:Q60OX62ZxIxhjUXEbk6f7wvN19yiZ9IveNAf6qtd4cdTjeUvGu2Biw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedugdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Q60OX9H4OIuaSHJtEUuR5CrInRfwmTQsaNIEExsg4Nfv-4bFA7Y8gQ>
    <xmx:Q60OXy4P2gyNlMZrsAXmuHF-v2VfWz90hTyR7y1HKp96T8InJJ1Q5Q>
    <xmx:Q60OX702x4m4BnPwAFehs9uwgafRNAVJrduU0Q9Fp0KXWjWzNQX_Ig>
    <xmx:RK0OX7N8VeVHcLKqTeD928vWazM4kacdIqR08olfem4r7FltfJXjng>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A385030600A3;
        Wed, 15 Jul 2020 03:16:19 -0400 (EDT)
Date:   Wed, 15 Jul 2020 09:16:17 +0200
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
Cc:     linux-usb@vger.kernel.org,
        Miguel =?iso-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] cdc_ether: export usbnet_cdc_update_filter
Message-ID: <20200715071617.GB2305231@kroah.com>
References: <0202c34b1b335d8d8fcdd5406f5e8178b4c198ec.camel@wxcafe.net>
 <7dbc46a51a7a2b8318418a0d40af3353b8f812c2.camel@wxcafe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7dbc46a51a7a2b8318418a0d40af3353b8f812c2.camel@wxcafe.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 09:32:12PM -0400, Wxcafé wrote:
> Fixed the title, sorry

That did nothing for us, you have to send a new patch series, we can not
hand-edit each patch for stuff like this :(
