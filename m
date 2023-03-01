Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A006A6885
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 09:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjCAIB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 03:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCAIBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 03:01:53 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7671D37569;
        Wed,  1 Mar 2023 00:01:52 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F37F5C006E;
        Wed,  1 Mar 2023 03:01:49 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 01 Mar 2023 03:01:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1677657709; x=1677744109; bh=HiNMFVsaBw
        wCxMOFcvgCnu4C3JGr7mO5AhegKiv449U=; b=Iek9K2kvPfnHfSxaaV5b+LYbwJ
        2Wvnq9VrP6J2WyAB/D87b5aW1f1L0puj8CMuHlCgSLSoW/VkH2Uf6EIM3hfvOjJY
        wLaIc+8W5OzSjRJ+iwL9wAV2Z6b4HfBeVde0BGPE7VUz0eSVgrv835TKt4UNUNTv
        N8yf+04nEu40z7AnBjAg/UcSP88fmZkQLjq0vN7g2Co68qH1N5QVBjUbVPVwauNT
        EsZK50EnmveqUWgo/Im/fGY4neKa8v2rDs8DVvOs1D+pK0CnsstgekihohKOSbKB
        JZlK2bTvs38Fa8JJVgp7yaUP5F9udIRrf41NCahNhKsmANgNB0KtFX8Rt9rQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677657709; x=1677744109; bh=HiNMFVsaBwwCxMOFcvgCnu4C3JGr
        7mO5AhegKiv449U=; b=hH5nYC9cimwawQ4osP7+SYD2eF6xutXdIAi9tcrpZZgR
        MSEM13ehfcMamfy1q6ri+sEm4qYYyrDa9TUc4h/Dz2QngWk7QkFuiIYdyaGQIUDw
        LHCB9Gy/Kg3LLqiGUKzkHbBjBnw0J0IneN3Al5JevOQn1VzVQ4lYznAdjV1zYE1q
        UxZpScMbg+0gVQXHt4GbY86Y2ocBl5TL5GQpLkVEAjwENqTl10xcmeZpPZAktf6p
        bMs7LdmXKmC1f2s6DUWI1N5yMGmuGmCK/YQ93E7IsMA+9/tiHxNndeIC/fRW+DjH
        L2vpNSAD1mYgOvpH78nRpdF20O1dlIKxMwm0xW0Rww==
X-ME-Sender: <xms:awb_YxNsQZBw_husNUreOec4Nsq7E5jwO7RsMTDtW3fpPI7zHXk2BA>
    <xme:awb_Yz8ybpZ-CBl2KR3OpPStkcfsHJJ9CQyNC1bqGlAwFzyF4YEgurcmejq_DgWPT
    9--MorystY6eBbv7dk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelgedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeevhfffledtgeehfeffhfdtgedvheejtdfgkeeuvefgudffteettdekkeeu
    feehudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:awb_YwRXhPnqjcjcTOFwlPAJwwF2MaowW_aeYBJI88QXyaIWZaqboA>
    <xmx:awb_Y9sQGhgvWIBrfQejaZTGXI9OE-bTU8zmkzZgAAMD08L57u79ag>
    <xmx:awb_Y5ezZV44Fw1hiFCUQD8B3C9REGfdEOyv1oN03lMnJm8HGsg1Hw>
    <xmx:bQb_Y_9WfNm3G3sMwT_z2CYwZMVOiwvUkT5p_ruxxvCU-NVmXfpVwQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A5E78B60086; Wed,  1 Mar 2023 03:01:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-183-gbf7d00f500-fm-20230220.001-gbf7d00f5
Mime-Version: 1.0
Message-Id: <6cfc194b-9d30-47d5-8ea9-fa5c13ad0e7c@app.fastmail.com>
In-Reply-To: <866973b7-1f54-21a3-79aa-992ed0594c1a@lwfinger.net>
References: <20230227133457.431729-1-arnd@kernel.org>
 <3d8f28d7-78df-5276-612c-85b5262a987a@lwfinger.net>
 <c17bff4e-031e-4101-8564-51f6298b1c68@app.fastmail.com>
 <e9f8501f-ede0-4d38-6585-d3dc2469d3fe@lwfinger.net>
 <7085019b-4fad-4d8d-89c0-1dd33fb27bb7@app.fastmail.com>
 <18be9b45-e7c1-9f81-afeb-3e0d4cfe5f73@lwfinger.net>
 <31fee002-db3b-43d9-b8bc-5a869516c2d7@app.fastmail.com>
 <866973b7-1f54-21a3-79aa-992ed0594c1a@lwfinger.net>
Date:   Wed, 01 Mar 2023 09:01:27 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "Dominik Brodowski" <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     "Bjorn Helgaas" <bhelgaas@google.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Hartley Sweeten" <hsweeten@visionengravers.com>,
        "Ian Abbott" <abbotti@mev.co.uk>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Kevin Cernekee" <cernekee@gmail.com>,
        "Lukas Wunner" <lukas@wunner.de>,
        "Manuel Lauss" <manuel.lauss@gmail.com>,
        "Oliver Hartkopp" <socketcan@hartkopp.net>,
        "Olof Johansson" <olof@lixom.net>,
        "Robert Jarzmik" <robert.jarzmik@free.fr>,
        "YOKOTA Hiroshi" <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 1, 2023, at 02:13, Larry Finger wrote:
> On 2/28/23 02:37, Arnd Bergmann wrote:
>> My intention was to keep Cardbus support working with old defconfig files,
>> and I've not moved CONFIG_CARDBUS into a separate submenu between
>> CONFIG_PCI_HOTPLUG and CONFIG_PCI_CONTROLLER but left the driver in
>> drivers/pci/hotplug. I think that's the best compromise here, but maybe
>> the PCI maintainers have a better idea.
>
> I did a bit more investigation. My original .config had CONFIG_PCI_HOTPLUG not 
> defined, but did have CONFIG_CARDBUS and the various yenta modules turned on. 
> With your changes, the CONFIG_PCI_HOTPLUG overrode CARDBUS.
>
> I thought mine was a corner case, but now I am not sure. As stated above, the 
> Debian 12 factory configuration for ppc32 does not turn on PCI hotplug, but the 
> x86_64 configuration for openSUSE Tumbleweed does. The x86_64 configuration in 
> Fedora 37 does not contain CONFIG_PCI_HOTPLUG, but does have CARDBUS set.
>
> It seems that several distros may get the wrong result with this change,

As far as I can tell, this should work with the changes I described
above, since CONFIG_CARDBUS no longer depends on CONFIG_PCI_HOTPLUG.
I now uploaded the changed version to

https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=pccard-rework-2

    Arnd
