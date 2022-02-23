Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8D14C09EC
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbiBWDGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiBWDGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:06:36 -0500
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB3A56C19;
        Tue, 22 Feb 2022 19:06:10 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 701D85803E9;
        Tue, 22 Feb 2022 22:06:09 -0500 (EST)
Received: from imap49 ([10.202.2.99])
  by compute2.internal (MEProxy); Tue, 22 Feb 2022 22:06:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        sladewatkins.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=/WQK49W8GxXyK9
        YnBpCAPS3p+vBZF3m8kdDflUfTGps=; b=jDYPanjJ0l7ayKHV2D3mosn3kgcD2H
        0mrWJ3TRL0a/UtQPxHRRLSpmRjmMDgjO3JwgROUCSg2HHC/eGwaL//PnW/AJ+hlQ
        kdq6TxH4OxEoD4YdYamGehF5ub3JCPNPz8XxbfdBljbZ5Z3u30mFYWKfmatVU1le
        GRWwrGVJDEcgZQwTZ7kbducNkGfDVLtqly9BM1DwGt/mGKrTi4XtZofvbk6eFyH2
        ZUw81DdVAXWxaKQ5tI4rkbhp4ZDFkxc/Z3zUIB9Jt6OfxhQfWEF+L4+zhgxi+3M5
        n14ff42YelRb1R+i8EWUtm74VE+gPaJ9e46MgoAfg3F+0YHZSloz91UQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/WQK49W8GxXyK9YnB
        pCAPS3p+vBZF3m8kdDflUfTGps=; b=oH0iKW615JNU/dnWMiLfSEh3lBBQEEJ7P
        PNPojxqKeOVHmMX1EA7ow708yXLiPvGfQLY+IzqnjDxVYRdTKYEcc047Ej0dN0o4
        eXFmNibFcE9bMx2I0L3WVeIfWQmQjXNqqdThVDIY+NC/C5hZvD/hgvsWga6Ofzme
        FGZ94SlVF8PLGzoiLYjzedwL28JypG58Jny4W7+xnncqWUpdqG7hhi1IvlsBeRpw
        dT5FybWNu8GNiFgGTKnZNPAbe5AzJ5ipHRldBCe9bZADh//OG2OqERwNB/t2qjIN
        v26PHnJWxir64u/4Ql2puW5S26bGTbrCmnv9jBmWslPlbT7QOud1Q==
X-ME-Sender: <xms:oKQVYipo7dlC_VoK0OYJHj0YN3xM7G5NP_FR5_NHDvEahXM41bx7XQ>
    <xme:oKQVYgoyWdCfznMfvXJwLVg1MwkS0KSiUmtFIbF7s-m1Q3skK-kbtHDwYKvkAk1Ih
    c26i49ghEQJKpdiNLk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeelgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhlrggu
    vgcuhggrthhkihhnshdfuceoshhlrgguvgesshhlrgguvgifrghtkhhinhhsrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeuieffteejieetgfevteelheevudehteeihffhteehtdet
    leegtedtvdevvddugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehslhgruggvsehslhgruggvfigrthhkihhnshdrtghomh
X-ME-Proxy: <xmx:oKQVYnOih52Ne5XyhxWZoneGzAUySweh_Fm1u67ISPkhWh6eaJADEw>
    <xmx:oKQVYh7pmq8qGDDtkw23vMlJ8RoibxqaW4XMx0DUh0BYubOnxkX-Xg>
    <xmx:oKQVYh76URoF8nAMP4NG4fdqJQ0oMUBquDWlOELF2Q0uEA1SmOWHdg>
    <xmx:oaQVYrsNgALnslbkKk6kwr9Xb1kfwSw8Q8ZjBxQrjnJIqsFWlXNVMv8ul_k>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 9338DF6007E; Tue, 22 Feb 2022 22:06:08 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <d8dcb9b9-02ab-4992-82fc-7faf0b388aeb@www.fastmail.com>
In-Reply-To: <61892434-1007-1aa0-f686-d66409550c84@metztli.com>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
 <YXY15jCBCAgB88uT@d3>
 <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
 <61f29617-1334-ea71-bc35-0541b0104607@pensando.io>
 <CA+pv=HOTQUzd0EYCuunC9AUPOVLEu6htyhNwiUB1fTjhUHsN5Q@mail.gmail.com>
 <61892434-1007-1aa0-f686-d66409550c84@metztli.com>
Date:   Tue, 22 Feb 2022 22:06:07 -0500
From:   "Slade Watkins" <slade@sladewatkins.com>
To:     "Metztli Information Technology" <jose.r.r@metztli.com>
Cc:     "Shannon Nelson" <snelson@pensando.io>,
        "Benjamin Poirier" <benjamin.poirier@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "Lijun Pan" <lijunp213@gmail.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Edward Shishkin" <edward.shishkin@gmail.com>,
        "ReiserFS Development List" <reiserfs-devel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        vbox-dev@virtualbox.org
Subject: Re: Unsubscription Incident
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20, 2022, at 6:54 PM, Metztli Information Technology wrote:
> I will resubscribe to Linux Kernel Mailing List 
> <linux-kernel@vger.kernel.org>; unless, of course, I have been placed on 
> a black list by the Penguins and/or their 'morally virtuous' 
> govt/corporate overlords ;-)

Hi there,
I doubt that you got black listed, or that anything like that is what happened here... I personally believe your situation may've been a fluke, but it also may not have been. Hard to tell because I haven't seen anything else come across my inbox similar to this besides your email. Who knows.

All I can say for sure is I haven't seen your name cross my inbox in a _while_ so something definitely happened.

Cheers,
Slade
