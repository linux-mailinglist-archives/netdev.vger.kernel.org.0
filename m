Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33FEF511F4A
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242118AbiD0QMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242149AbiD0QLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:11:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACFA3656CA;
        Wed, 27 Apr 2022 09:07:43 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id j6so4310260ejc.13;
        Wed, 27 Apr 2022 09:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qNVAjw1AVjFVcrN+8QdteFz8g5Tvmj9OwlQ+tinUFvQ=;
        b=p0CjnKtsMnzlXSan+xmDjBfzonLD0gMApaxy0ct+kXepD1c+CgoWufpZ7xlPEjp13e
         gLcGyKMBQSBpyQPF9cxAyV98wvkH2yc5Z2e/CdRw3BEj2JTPqOmDipATYqk+hPXocdlp
         qUsLCSk33xqCPmgw1OG13zKZRtq65VlMmW322pA39UFYq1pD/jL3ROc68c5Ary5HCd9Y
         +w4TK2cP2obzOWnNfnu8mmoGnCUxjhieK5BJ9i0wyqx35enq3XkiauZmrYiRT5IjLVRT
         LaWuoi3W72c8fEU3gKXTbjUgp+E4eVwTMEIM/a4rqTwxFifdQEEJSYi2nq6yxX9Fbp9j
         6lqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qNVAjw1AVjFVcrN+8QdteFz8g5Tvmj9OwlQ+tinUFvQ=;
        b=FB40+tn3R0+LtfSU89xmN0mRKwnGpvvTSTtYtVr3Xodvc8CBu2jkIYgSzPPKf1JK9s
         j7iuBNhaq6It0iIULkwyzzOCpslrwKXSD7odZnkgC64LoA7PSs7CJTUB7FbrHEcT9WxY
         iSc85u+ET83O3XWbJJP3WAI8E+FpDosRRNJ83+AoR6EAxj54BnnOKrBcM5wHuGe+THcI
         Pnz9h0R5Cgi/Mc4EhCXxKYTELHAHaCIa4EGdIxKV25O+KzmsD7RDGGKqUTZDWwamGeO5
         kJ+YlmLRPCGoitCLExzZRFfatrWIMO/V1iup/qlyUpNashtqtp4/GFB7um/a8zYFUoIG
         HeHQ==
X-Gm-Message-State: AOAM530GcY8Sgossef9wxrr6AKJV1LZDQeVTqApQaNYzH8KWPnHF9QPx
        hP5Lex1uLqrxhh6XatvVoK0=
X-Google-Smtp-Source: ABdhPJzzqwCBxB0YQi8NRI6etX4swRNXByESX+xp6uAoxTdSxi7YiN64Mq1z4chsQQMWKW0/AR1L2A==
X-Received: by 2002:a17:907:98eb:b0:6f3:ce56:c1a2 with SMTP id ke11-20020a17090798eb00b006f3ce56c1a2mr2982061ejc.173.1651075633659;
        Wed, 27 Apr 2022 09:07:13 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:13 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Jakob Koschel <jakobkoschel@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v5 00/18] Remove use of list iterator after loop body
Date:   Wed, 27 Apr 2022 18:06:17 +0200
Message-Id: <20220427160635.420492-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the list iterator loop does not exit early the list iterator variable
contains a type-confused pointer to a 'bogus' list element computed based
on the head [1].

Often a 'found' variable is used to ensure the list iterator
variable is only accessed after the loop body if the loop did exit early
(using a break or goto).

In other cases that list iterator variable is used in
combination to access the list member which reverses the invocation of
container_of() and brings back a "safe" pointer to the head of the list.

Since, due to this code patten, there were quite a few bugs discovered [2],
Linus concluded that the rule should be to never use the list iterator
after the loop and introduce a dedicated pointer for that [3].

With the new gnu11 standard, it will now be possible to limit the scope
of the list iterator variable to the traversal loop itself by defining
the variable within the for loop.
This, however, requires to remove all uses of the list iterator after
the loop.

Based on input from Paolo Abeni [4], Vinicius Costa Gomes [5], and
Jakub Kicinski [6], I've splitted all the net-next related changes into
two patch sets, where this is part 1.a

v4->v5:
- fix reverse-xmas tree in efx_alloc_rss_context_entry() (Martin Habets)

v3->v4:
- fix build issue in efx_alloc_rss_context_entry() (Jakub Kicinski)

v2->v3:
- fix commit authors and signed-off order regarding Vladimir's patches
  (Sorry about that, wasn't intentional.)

v1->v2:
- Fixed commit message for PATCH 14/18 and used dedicated variable
  pointing to the position (Edward Cree)
- Removed redundant check in mv88e6xxx_port_vlan() (Vladimir Oltean)
- Refactor mv88e6xxx_port_vlan() using separate list iterator functions
  (Vladimir Oltean)
- Refactor sja1105_insert_gate_entry() to use separate list iterator
  functions (Vladimir Oltean)
- Allow early return in sja1105_insert_gate_entry() if
  sja1105_first_entry_longer_than() didn't find any element
  (Vladimir Oltean)
- Use list_add_tail() instead of list_add() in sja1105_insert_gate_entry()
  (Jakub Kicinski)
- net: netcp: also use separate 'pos' variable instead of duplicating list_add()

Link: https://lwn.net/Articles/887097/ [1]
Link: https://lore.kernel.org/linux-kernel/20220217184829.1991035-4-jakobkoschel@gmail.com/ [2]
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [3]
Link: https://lore.kernel.org/linux-kernel/7393b673c626fd75f2b4f8509faa5459254fb87c.camel@redhat.com/ [4]
Link: https://lore.kernel.org/linux-kernel/877d8a3sww.fsf@intel.com/ [5]
Link: https://lore.kernel.org/linux-kernel/20220403205502.1b34415d@kernel.org/ [6]

