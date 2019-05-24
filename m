Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C3229DAA
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfEXSCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:02:10 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:42595 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfEXSCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:02:09 -0400
Received: by mail-vs1-f66.google.com with SMTP id z11so6417925vsq.9;
        Fri, 24 May 2019 11:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=/c0F+parR6bN86hWiP5Ifn7/OM8gtFo/WuXGn5Kkvqs=;
        b=dUwYBvqs93lG4d1TS6FrWkYK9tjJF9joMVDSL+Frt8pUlxzut/kmSCA5F9x/IU5HLf
         OoBHrLOkbUQma48nVJBleDgqrJYVB9bno19PtnMIXm5MSRl+TW2Y9qNDWFMqQv5ma4Ol
         WjSdzrRhIc2CGzwiPCiZ2vtm9QVt+AVcUFbE7KvdItXF/0I04vXPptA8DVj/hUxjHexf
         YACmhaHjnhH2pLJZ2Uh0kdLkjx5ur8m8pq0I2Y9zjKutjG8gBC5Ikse6SIkFwjELriH2
         bm0n3PU56/N2S+xOvd76Mmap0xep4s7CWFnsdlLexmCAlLuPb8MA15WBen61ogxWozmJ
         GYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=/c0F+parR6bN86hWiP5Ifn7/OM8gtFo/WuXGn5Kkvqs=;
        b=YnOAhwv+EO5OXsiRI2nnMyos/TAiNnlrtySkCLPlJyB2SURJTA6RC8SbPelX0cOFOe
         4BRIgPzTqnhu/Fsf1J0VT72EsenYM/xtl429YQFESu/UgZDA5/02GFVP3ZyCcfxx8plJ
         TN5CE94v4JFYxD/ptLzOV/x0bdZ56MZng5U8gOWsvd0wC7be7w6KcJOSMZaVeHbM8KJk
         PZWKYL+J9GG4uS0DibSMoW4dZ+3PU+zmP4zWCyl5tqbNIvP+gDZANLGI1rBQ+fY0KX7u
         /IHWf/cSOpxAE5+sYdJUTMlqRInQ0SQBHOpChkhWiwqOufAeN/1XgIxYWKVD9g5qIp0l
         HKLA==
X-Gm-Message-State: APjAAAUr3yJnN6bS09lbR00nQUPT28xQTs+JehxOTQ1bYFvOch85aCCU
        Wnhd88q6XnyJUKs8Tn55Rqc=
X-Google-Smtp-Source: APXvYqxS4mzDEMERjcL67EgtD6e5diif4cIUBmshIzjF+TLMxZDmVbuWnI4nfhb3p3xAxtS9dD6oDw==
X-Received: by 2002:a67:f303:: with SMTP id p3mr41457576vsf.166.1558720928663;
        Fri, 24 May 2019 11:02:08 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w9sm1537289vkh.53.2019.05.24.11.02.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 11:02:07 -0700 (PDT)
Date:   Fri, 24 May 2019 14:02:06 -0400
Message-ID: <20190524140206.GF17138@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] net: dsa: implement vtu_getnext and vtu_loadpurge
 for mv88e6250
In-Reply-To: <20190524085921.11108-4-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-4-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 09:00:27 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> These are almost identical to the 6185 variants, but have fewer bits
> for the FID.
> 
> Bit 10 of the VTU_OP register (offset 0x05) is the VidPolicy bit,
> which one should probably preserve in mv88e6xxx_g1_vtu_op(), instead
> of always writing a 0. However, on the 6352 family, that bit is
> located at bit 12 in the VTU FID register (offset 0x02), and is always
> unconditionally cleared by the mv88e6xxx_g1_vtu_fid_write()
> function.
> 
> Since nothing in the existing driver seems to know or care about that
> bit, it seems reasonable to not add the boilerplate to preserve it for
> the 6250 (which would require adding a chip-specific vtu_op function,
> or adding chip-quirks to the existing one).
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
