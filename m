Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC806D5FB6
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbjDDL6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbjDDL6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:58:16 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E52B4;
        Tue,  4 Apr 2023 04:58:14 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w9so129538213edc.3;
        Tue, 04 Apr 2023 04:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680609493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2O5BT4d+Plee9uK16XwjOXySxN/SdqX/u56QBebNlEY=;
        b=kCKuIal+F86YF4Q0qqMvmxV3OWyYbc2kq56MxP+75vnMxnXUHNCy8KXKlJ3969VpN4
         7MitUr1ey78Zv13m56YsJOPEMQ7ehKHDB94P40+EBOowPXmNgtDrg9nZizxx0iPDFfdS
         /123rm3pNsb1eel+Fl26bZ28xxqEFw7eh0+uplbANgcISA+ymFoHN46G9N74covDO+iv
         bRkaCWrhMNHMAQQxS14HJkYPfrWLtchoa6FNGx3xLVyqqwa427zaqJUWApylSKybgT5L
         ZpTpfeUpzxHfXgDEWraRsZdeyvl0yiUr6V4BNDcRYN0LmmlrAV8mrjB6odNzGZAEYd3S
         ss6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680609493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2O5BT4d+Plee9uK16XwjOXySxN/SdqX/u56QBebNlEY=;
        b=ED3WKExuy41NaxlrNvglGYZ9r/Lh98NWBlCe3wcxQiumVB6asRhe/CNzLyMcp8UEmB
         tK6eayOxrBEg4jokYPed8qYZOoRKs6DBZTsKq2PMwFJIlhPAWyCc+EGJYDfcaKMtOlo1
         8PyHx8b/8CMPh6/gnO2soXlk+zfeB/FapW1jC+DY1dE8UhJtiX7VrgO9IdmwwbjsD4gZ
         kbcHgg5UbEDcZHVwGQDbPw+xLYosB5jgJ+IdkO3asjdXenZ4Kq+B2hAph/bT11bF4B7s
         mxw08/cNQ/Qrnv5jWiaw/2+aG7NJaR7HG7lU9oEnIez+v+X1zjqAY2NYEAZwmRBAWbFq
         FlaA==
X-Gm-Message-State: AAQBX9fC293fuJQkq36czlt3bTTWe/jGFiVziWxryTfiFkoqEDIjrUFu
        DFiXs9U/hc2vC4G5K7USvz8=
X-Google-Smtp-Source: AKy350bL/JyzCjxrIEYfRxqTD6B6ddRnhA0JirPlEFAGicLWj04kosnTaWdcG/YDxwZIvyVG5AwFCA==
X-Received: by 2002:a17:906:79c3:b0:922:78e2:7680 with SMTP id m3-20020a17090679c300b0092278e27680mr2033954ejo.52.1680609493258;
        Tue, 04 Apr 2023 04:58:13 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id xe8-20020a170907318800b00947ce2a1cb0sm5178645ejb.73.2023.04.04.04.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 04:58:13 -0700 (PDT)
Date:   Tue, 4 Apr 2023 14:58:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 4/7] net: dsa: microchip:
 ksz8_r_sta_mac_table(): Avoid using error code for empty entries
Message-ID: <20230404115810.eznhi7jck7g2loje@skbuf>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-5-o.rempel@pengutronix.de>
 <20230404101842.1382986-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404101842.1382986-5-o.rempel@pengutronix.de>
 <20230404101842.1382986-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:18:39PM +0200, Oleksij Rempel wrote:
> Prepare for the next patch by ensuring that ksz8_r_sta_mac_table() does
> not use error codes for empty entries. This change will enable better
> handling of read/write errors in the upcoming patch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

FWIW, it looks like for port_fdb_add(), you could skip the search in the
static MAC table, as long as you just keep a reference to the last
populated index, because the bridge won't allow, to my knowledge, adding
the same MAC address twice (this has changed when we stopped allowing
bridge bypass operations in commit b117e1e8a86d ("net: dsa: delete
dsa_legacy_fdb_add and dsa_legacy_fdb_del")), and so, having space would
mean that the last populated index is < dev->info->num_statics - 1.

This guarantee and optimization possibility is different from
port_mdb_add(), because there, you might be asked to modify an existing
entry, and so, you still need the search to find it. But still, you
could limit the search for the remaining 3 operations - port_fdb_del(),
port_mdb_add(), port_mdb_del() - just from 0 to that last populated
entry, not to dev->info->num_statics, which should still accelerate the
operations a bit.
