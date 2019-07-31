Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E0A7BEAD
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 12:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfGaKyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 06:54:53 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:46378 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaKyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 06:54:53 -0400
Received: by mail-vs1-f67.google.com with SMTP id r3so45812871vsr.13
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 03:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=CN6bGVNT6PwUD35aJJc0dJRuvFhfXbJfUlSVRS9yF0w=;
        b=czP2MZklSJu0CVZreSFr8XvP6QlklmjWzSNJsOxrzgOATc+B75//4Jr2sfH5QDpRpo
         aNAEEExAT/cWq77wSJNrptlR4qLObSC6qg86PXz2HHs93rL0XyGo4CklzczmF+78L0ve
         XY6+BOSvJZf7W7j6rhwiOJjJdFRLuGup5yU3XkX1Yf8ejI8oyG+Th1pyg5v0TltCcTLY
         bgQMiC/DdtIm/0vI0EXdZd7UTz4nihJ2lMbYAnw3tEDnFG/ONWpJVatrsn6EMUvG7lti
         LE62lwFHMnEE73dZb9G7tyHpqSa07UVIWVgEtXSul1afg5+ECgFxYVeitn6i9+CcwwR5
         URNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=CN6bGVNT6PwUD35aJJc0dJRuvFhfXbJfUlSVRS9yF0w=;
        b=J7hyNto4eNvLfx9i4gKqUEtb5EfEvpcPfYp583PeU+KUZm6IHe/RfitNfGUuZHYyA1
         AsCHH+EOSXEFcEysa/GVEuPdM9398cEhSzbAWdlLOtaba/8ma5epfHM07kijwsnkQXjQ
         jKXcA/IXMna47Ja3ik3unGacu4HqjSz5oUIp97XGfeSM025Pio9Pi9zmRvlbNlBWvgGq
         2zoRirrxeiF6OMwvw5o8ouCGoTaVEWwwDaKbwkTQKIBeRo0GockrHNAlnPSAWs3nuvpb
         7k2TmuStPYw2hMS0eVN4ZOvEbbZZEXvG6PABrNOfpmsTgT9ePhBQI2InMbh/uzDC6Cgx
         uWxw==
X-Gm-Message-State: APjAAAVDh/sUo9XIVRuO+W9jgyRnQ3UxQCaZ173d8dZ3/ZT6SyOY7Nmr
        bifN3j0snw4cuhLmP9mVqRcyNOJLH657Ubf7chc=
X-Google-Smtp-Source: APXvYqzpmnUO3qECLe9prky/vDLIcKoA/vRPBYsLNc2tanHLG910uyq9Iw3tnY0Yx21n/mOc+UO65mefdAQULcivgWg=
X-Received: by 2002:a67:ee12:: with SMTP id f18mr61807817vsp.186.1564570492332;
 Wed, 31 Jul 2019 03:54:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:2616:0:0:0:0:0 with HTTP; Wed, 31 Jul 2019 03:54:51
 -0700 (PDT)
X-Originating-IP: [2620:113:80c0:5::2222]
In-Reply-To: <CA+FuTSfnqV4zGvW+W0fh+=X-wm8rz1O5ZqGKXpxSVN1vPMD+sw@mail.gmail.com>
References: <20190730113226.39845-1-dkirjanov@suse.com> <CA+FuTSfnqV4zGvW+W0fh+=X-wm8rz1O5ZqGKXpxSVN1vPMD+sw@mail.gmail.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 31 Jul 2019 13:54:51 +0300
Message-ID: <CAOJe8K2TE-g=MwEHH82e1UryANymFbtgE60Ltpf9pwaHLVDSfA@mail.gmail.com>
Subject: Re: [PATCH net-next] be2net: disable bh with spin_lock in be_process_mcc
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com,
        Network Development <netdev@vger.kernel.org>,
        Denis Kirjanov <kdav@linux-powerpc.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19, Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> On Tue, Jul 30, 2019 at 7:33 AM Denis Kirjanov <kda@linux-powerpc.org>
> wrote:
>>
>> Signed-off-by: Denis Kirjanov <kdav@linux-powerpc.org>
>
> This is a partial revert of the previous change to these lines in 2012
> in commit 072a9c486004 ("netpoll: revert 6bdb7fe3104 and fix be_poll()
> instead").
>
> The commit message is empty. Can you give some context as to why this
> is needed and correct?

The idea was just to make some cleanup. Now I've checked that be_process_mcc
is invoked in 3 different places and always with BHs disabled except
the be_poll function but since it's invoked from softirq with BHs
disabled it won't hurt.


>
