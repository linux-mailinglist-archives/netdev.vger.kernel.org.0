Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300AECB696
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfJDIoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:44:15 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33619 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDIoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 04:44:15 -0400
Received: by mail-ed1-f65.google.com with SMTP id c4so5134697edl.0
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 01:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I/WyVUJa+u8medY7nHbZcpEc/41V0xxInaEJMyN+W80=;
        b=ryTUr5LEM6kBRQEE7cLLi2vrv8sTQqg4T7XVMjSLXW/h8oAuU8e6uWCfzcYaADL50c
         PU7x1ZxRvpzLmNZpIn/Z6GzHZM2GKmdOF/NInN10aGwFRku20fuk7cFP/Gmj3ltSV9yV
         bBgA0bS6yD7eboaPGwowybFI7ufRAE0x/KjN6bv94Puy/zPcVEQ7/MLyr+XIqWIcACF0
         fB9vRsrf37u3E+zm/MLzUdm0vC8c3pSQjoh2Eov8RqOa/zhe5i8fsr2oaLIrJelzpyy9
         TgI15LFnXJrrhVjPSBSf84IFMaveLh0InT/H5k7xujulqqiWTLQG4d30s5/oBeYZO/cb
         1sTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I/WyVUJa+u8medY7nHbZcpEc/41V0xxInaEJMyN+W80=;
        b=tVGZ9IpaVkte8HqddesyEytlInt3kCZl7GaOxpp+slmpPaffEm66M/wzhMD8RTC+nH
         tEpsPlTuSvJRbhV+BjiKDz8Oopb3rDXhtZ0QaJzBfATjFMAwwttOxdZBvDq3Tbm9HaKy
         zT5rPUmXF4lfTUO6NoPh1Hohky59Ux15RTdlM3WI+j+Aq463tB4YqPiP4K7mVCuzvrYA
         IbSpaXfTaTjfroaHvVLtBo+gVvzEroleUUxV82SLQ0k8LUhzAeycqZM713asX7Vm/Jbv
         UfahBk43llOG/8JgTqp0iw9fX5eaKa6OAXGdJKiTOUvCvDjRDtS1LdVRo5N9hugp8cfa
         VFnQ==
X-Gm-Message-State: APjAAAVKOBfqCiU/A2PDs4++Uh5m2TIY1crz7P5sk3VJC/m380qxyQp9
        19wZWAE8RnHzo7UvGYUg7kWTOWFE1555hhZo2Bg=
X-Google-Smtp-Source: APXvYqzRCIc5mRHpZPkiSZlE47szY3RCd3+U8dyxKwJqvUHTlwaBS0hqbyf7P6ClkoqdLM6WvuVDM1D4MI4eMQBVFVk=
X-Received: by 2002:a17:906:7294:: with SMTP id b20mr11145219ejl.216.1570178653171;
 Fri, 04 Oct 2019 01:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191004013523.28306-1-andrew@lunn.ch>
In-Reply-To: <20191004013523.28306-1-andrew@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 4 Oct 2019 11:44:02 +0300
Message-ID: <CA+h21hq8G2fMZenAF_inYxQXePJe41Lk6U8AsJ-7e19YYTp7Wg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] mv88e6xxx: Allow config of ATU hash algorithm
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, 4 Oct 2019 at 10:55, Andrew Lunn <andrew@lunn.ch> wrote:
>
> The Marvell switches allow the hash algorithm for MAC addresses in the
> address translation unit to be configured. Add support to the DSA core
> to allow DSA drivers to make use of devlink parameters, and allow the
> ATU hash to be get/set via such a parameter.
>

What is the hash algorithm used by mv88e6xxx? In sja1105 it is simply
crc32 over the {DMAC, VLAN} key, with a configurable polynomial
(stored in Koopman notation, but that is maybe irrelevant).
Are you really changing the algorithm, but only the hashing function's seed?
If the sja1105 is in any way similar to mv88e6xxx, maybe it would make
sense to devise a more generic devlink attribute?
Also, I believe the hashing function is only relevant if the ATU's CAM
is set- (not fully-) associative. Then it would make sense to maybe
let the user know what the total number of FDB entries and buckets is?
I am not clear even after looking at the mv88e6xxx_g1_atu_* functions.
How would they know they need to change the hash function, and what to
change it to?

> Andrew Lunn (2):
>   net: dsa: Add support for devlink device parameters
>   net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.
>
>  drivers/net/dsa/mv88e6xxx/chip.c        | 136 +++++++++++++++++++++++-
>  drivers/net/dsa/mv88e6xxx/chip.h        |   4 +
>  drivers/net/dsa/mv88e6xxx/global1.h     |   3 +
>  drivers/net/dsa/mv88e6xxx/global1_atu.c |  30 ++++++
>  include/net/dsa.h                       |  23 ++++
>  net/dsa/dsa.c                           |  48 +++++++++
>  net/dsa/dsa2.c                          |   7 +-
>  7 files changed, 249 insertions(+), 2 deletions(-)
>
> --
> 2.23.0
>

Regards,
-Vladimir
