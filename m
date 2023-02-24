Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13B16A23F9
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 22:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBXVx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 16:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBXVxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 16:53:55 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D9F1040B;
        Fri, 24 Feb 2023 13:53:54 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id ee7so2891502edb.2;
        Fri, 24 Feb 2023 13:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+5eSywMvV2ug+ZtsNbQkPbN0xmm97do2TILmiHXrX+8=;
        b=G+CJc7sIUwjc38V/esuyG+zjarKvIyr5/Ftov6HBUcrQ8cwpibx4Nb7UYgsYBJpyfg
         uLUuF3evXdITmGdk1LN8Wen/KjyBNqb3yDAxGQFmrlHZAobeA4IDLMr3EATS1LdnQ+21
         GnJiBRU+EJ4IxfEGI/26dOm9LDnkHeuL24fIInw1jo8CW29AvNIcZZtyCAhJ9HxPsBOE
         eYi4/bgxWZqOwFMY76P6bKZ/6S4t9CaGumPnCb/Az7q14GRrzrQ+voljxPka7ZtCJe5d
         xwb9840i1MUUvWErIuYmkAjg11DbF0/4kW+KOAsz5wp1Zkb+k56snjiCCkie8HAi4IcR
         MKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5eSywMvV2ug+ZtsNbQkPbN0xmm97do2TILmiHXrX+8=;
        b=hYnM88HeYi9vftogdlEda+giwHnap7Y9mr6w2ValE62tDsgQYe8n0OJktiOk2kfYN6
         6/5H1kYJHmGsxzB1LH/k1c6XabixGWPJC/fcfG/o/cQGUyDs6SdmO7jBXbF3GmEqngE+
         TZEo+5enIKowqkhAZS9eheIaj8u4u1Jzpdei3EPn0YWTHC2iACdk8m3rgpyVDk6ZHmFJ
         LAKzzG/m0Va9M+Bgp6lx2u5NxD+oQWC17b2h/gdkny9lD7uWRiKYF7i53fExYWzfI9vt
         rCsrj9j0OFLeJlmsjlFnrTgQetpr9BhvNZWuyKdxfQpMgQnf+0yUi09JkIt5E32PmTxJ
         8UjQ==
X-Gm-Message-State: AO0yUKUacFs1sXqiTrZiXK55sY8VqUGgrqY48o9q3+7pS/HKVuSbzUIz
        Ul2EgY4sm8yACCvW6F/f0sg=
X-Google-Smtp-Source: AK7set/R6z2ukq5j2KI3aOOQekMtWn24eajeyvRltqab/706R0jM5AVjF5p3+1ajfmn5P5oNVR4tGQ==
X-Received: by 2002:a17:906:e253:b0:85d:dd20:60a4 with SMTP id gq19-20020a170906e25300b0085ddd2060a4mr25171818ejb.40.1677275632606;
        Fri, 24 Feb 2023 13:53:52 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id og42-20020a1709071dea00b008e8e9859905sm31799ejc.184.2023.02.24.13.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 13:53:52 -0800 (PST)
Date:   Fri, 24 Feb 2023 23:53:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: microchip: add eth mac
 grouping for ethtool statistics
Message-ID: <20230224215349.umzw46xvzccjdndd@skbuf>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-4-rakesh.sankaranarayanan@microchip.com>
 <84835bee-a074-eb46-f1e4-03e53cd7f9ec@intel.com>
 <20230217164227.mw2cyp22bsnvuh6t@skbuf>
 <47a67799-27d9-094e-11c3-a18efcf281e2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47a67799-27d9-094e-11c3-a18efcf281e2@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 05:07:01PM +0100, Alexander Lobakin wrote:
> It's not so common for people to show up back in the thread after you
> ask them to show godbolt / asm code comparison.

idk what godbolt is, but if it's some sort of online compiler, then I
suppose it's of limited usefulness for the Linux kernel.

Easiest way to see a disassembly (also has C code interleaved) would be
this:

make drivers/net/dsa/microchip/ksz_ethtool.lst

This is also useful to see precisely which instruction went boom in case
there's a NULL pointer dereference or something like that.
