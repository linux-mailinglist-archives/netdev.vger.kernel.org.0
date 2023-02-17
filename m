Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8486669B170
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjBQQxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjBQQxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:53:52 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A046747A;
        Fri, 17 Feb 2023 08:53:50 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id bt27so1266587wrb.3;
        Fri, 17 Feb 2023 08:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cJDJaDfdMj+RHz9hciHNs0/mJl/VtOxDjRrDBxxcfOI=;
        b=WXWNpBTHr+H5wXLmlD3RZlu3yJrvwsM4nZZWj9RmA3PLPw++20nKVV77TJFqowhaFb
         7OTAfOreukKfkWHeTvPglzBFqooOOcY/11p/8zpbJzg69t9JOdGh/kW4IRTzAoh2LtF4
         3mn9EmC34wM9U8n3yxK1ed2uPG5mIe6w1OZAFerRYWhVCa5+O4hOGdt2vo0bN4YnThOj
         4Rc2qlpyz+u5pyUDuCYxF43kC4suDmIMhfuE20ulo5CGIdG3FosZtv6FzdLevPfc9bsG
         akzw1w4TLmO6nWKIL+0WYVcUyENc2eJelpcC4Z0IFbVk2j0d1TDGZMwfJGiFD5ny1oXz
         NIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cJDJaDfdMj+RHz9hciHNs0/mJl/VtOxDjRrDBxxcfOI=;
        b=HG2KSEZz5rTY8Q9jwYcgX4L4lirWpxfANQW7LvcpEDY1m+MbXx2wDZDMGqaM1JKwkw
         uYC6YB7kuY826q6bX3/bIskysAAZDJ27E0W9MecVynlja5KmSt0E3QmBmT/WSt8ZpUnd
         +f+WdpkO8Tv5jHfWMBFGDVybVQZhZdAh2yp0Li/EH6TiulXE3z1DuHX4kMuSdyW+yWPj
         peQ/W4IwLE5gqU6YGARfHnDlqCT3krJTQ3kxodMPWNIoLrswu8a3VtUj/OMHe8SUoIZy
         Ef/vQXcp6kCHBqRiyHk3/Hl2t5ZOYcbrnAfo3JQM2P5sfAWf4RERHfcG7W2FRcsExtAF
         NQOg==
X-Gm-Message-State: AO0yUKX7nY/EzI+OlaMsIwJQ4k2priqUTrXG5T2JW2FGt1lsfSBrMtYZ
        DRmw3Rwdf1PkApt82A6vm3CV2HyEs3QjtA==
X-Google-Smtp-Source: AK7set/R/T+6J7p43DThvQiX0JZkk18cqmCsG4mZBT4XSCUrCIyrY1ZckbTSWvtxYBJUbugG4ioWsw==
X-Received: by 2002:a5d:58e5:0:b0:2c3:dd60:d749 with SMTP id f5-20020a5d58e5000000b002c3dd60d749mr256196wrd.47.1676652829215;
        Fri, 17 Feb 2023 08:53:49 -0800 (PST)
Received: from skbuf ([188.25.231.176])
        by smtp.gmail.com with ESMTPSA id s5-20020adfeb05000000b002c54c0a5aa9sm4757508wrn.74.2023.02.17.08.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 08:53:48 -0800 (PST)
Date:   Fri, 17 Feb 2023 18:53:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Thangaraj Samynathan <Thangaraj.S@microchip.com>
Subject: Re: [PATCH v2 net-next 1/5] net: dsa: microchip: add rmon grouping
 for ethtool statistics
Message-ID: <20230217165346.2eaualia32kmliz6@skbuf>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-2-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217110211.433505-2-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:32:07PM +0530, Rakesh Sankaranarayanan wrote:
>     Add support for ethtool standard device statistics grouping. Support rmon
>     statistics grouping using rmon groups parameter in ethtool command. rmon
>     provides packet size based range grouping. Common mib parameters are used
>     across all KSZ series swtches for packet size statistics, except for
>     KSZ8830. KSZ series have mib counters for packets with size:
>     - less than 64 Bytes,
>     - 65 to 127 Bytes,
>     - 128 to 255 Bytes,
>     - 256 to 511 Bytes,
>     - 512 to 1023 Bytes,
>     - 1024 to 1522 Bytes,
>     - 1523 to 2000 Bytes and
>     - More than 2001 Bytes
>     KSZ8830 have mib counters upto 1024-1522 range only. Since no other change,
>     common range used across all KSZ series, but used upto only upto 1024-1522
>     for KSZ8830.

Why are all commit messages indented in this way? Please keep the
default text indentation at 0 characters. I have never seen this style
in "git log".

> 
> Co-developed-by: Thangaraj Samynathan <Thangaraj.S@microchip.com>

Documentation/process/submitting-patches.rst:

Co-developed-by: states that the patch was co-created by multiple developers;
it is used to give attribution to co-authors (in addition to the author
attributed by the From: tag) when several people work on a single patch.  Since
Co-developed-by: denotes authorship, every Co-developed-by: must be immediately
followed by a Signed-off-by: of the associated co-author.  Standard sign-off
procedure applies, i.e. the ordering of Signed-off-by: tags should reflect the
chronological history of the patch insofar as possible, regardless of whether
the author is attributed via From: or Co-developed-by:.  Notably, the last
Signed-off-by: must always be that of the developer submitting the patch.
