Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5824FE027
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242771AbiDLMXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354327AbiDLMW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:22:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A816C94E;
        Tue, 12 Apr 2022 04:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k1kFbr4PJFmsHiVyh3odwUpl/FEunR2slPc9KbivmVs=; b=FJsGgOd6Jog/SVqJqtG82tp8gF
        GmofMqvYUa9rQRC13PSTLfmhxejGCEF6gS4x9w8uLHIZWizN5tXQvJ85FM+OjXDsvvshki/tqrWTR
        ijKqokXU7UeOILCkJWOmQfRrdgFUmI7ulHIUz6O//1a80snecUa4eRrVm1MTENQUInqEPHbeZPb2D
        unRlctmv3BT82g774UuWb9bM94zmpSy9Tu///xUdzOrE+iYwjfidcGftFycGjXYqjyemYE5BVqNNI
        TfjxE7pcrSZTtu7dijAp8lI9sMPrOI9Ksv+/xDzYHzORtMtioQ+vO+NNavrO13alkrr6dMoe/et7D
        lyMXRLFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58226)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1neEh4-0001o2-0I; Tue, 12 Apr 2022 12:28:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1neEgf-0002LH-Jc; Tue, 12 Apr 2022 12:27:57 +0100
Date:   Tue, 12 Apr 2022 12:27:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 05/18] net: dsa: mv88e6xxx: remove redundant
 check in mv88e6xxx_port_vlan()
Message-ID: <YlViPWWKhvoV2DLN@shell.armlinux.org.uk>
References: <20220412105830.3495846-1-jakobkoschel@gmail.com>
 <20220412105830.3495846-6-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412105830.3495846-6-jakobkoschel@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 12:58:17PM +0200, Jakob Koschel wrote:
> We know that "dev > dst->last_switch" in the "else" block.
> In other words, that "dev - dst->last_switch" is > 0.
> 
> dsa_port_bridge_num_get(dp) can be 0, but the check
> "if (bridge_num + dst->last_switch != dev) continue", rewritten as
> "if (bridge_num != dev - dst->last_switch) continue", aka
> "if (bridge_num != something which cannot be 0) continue",
> makes it redundant to have the extra "if (!bridge_num) continue" logic,
> since a bridge_num of zero would have been skipped anyway.
> 
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Isn't this Vladimir's patch?

If so, it should be commited as Vladimir as the author, and Vladimir's
sign-off should appear before yours. When sending out such patches,
there should be a From: line for Vladimir as the first line in the body
of the patch email.

The same goes for the next mv88e6xxx patch in this series - I think
both of these are the patches Vladimir sent in his email:

https://lore.kernel.org/r/20220408123101.p33jpynhqo67hebe@skbuf

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
