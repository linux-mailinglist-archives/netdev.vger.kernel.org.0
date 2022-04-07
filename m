Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B395C4F7CC9
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244263AbiDGKdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240653AbiDGKdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:02 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F98252E4E;
        Thu,  7 Apr 2022 03:31:02 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qh7so9812816ejb.11;
        Thu, 07 Apr 2022 03:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bOp7/tC9bFhm53CLsSm24svzgwwfQBWtUDQnB+bIBuE=;
        b=KXwh36Kseg3CVGevbGAE8a3Ax24ainsjSrWTaHc30TLr2jSFkdYRDP0MaSryXI8M4v
         FBHfLFYpoaQGSX3GW2cn0FoJDmWZ1vY3c3fg+wtOnngvNO9fE1sDRwmM6BGgex1DwxnF
         r4oLScN+3qnwGdSh7+7vGPHJ1nZj0pdz8DUgZEw73PY1+09R25O6X9g0y/cs1VDWQ6pv
         zV/3gMcje94ykVaOdS1+CfDw6AGlQ9cM/Szvnq8SvH1mSJj6CZ77tt22yeMFUhscgNni
         QxdGGaxRWKPWZXYuyzF9XzYRAt78E0o4Df2jSqk1sXM15r8hDe8ygGJ3e6wiHffdLIaw
         Lrog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bOp7/tC9bFhm53CLsSm24svzgwwfQBWtUDQnB+bIBuE=;
        b=Axg6plfRyVgrPeUHrlrylxowvoZllcY2QjEv3NCroSDHjELHvvLY/XAQonCg58nfES
         H+WW/rNyMhL1mlQhkyH0FcY28xXVjrOKCQtYCG2JVobEQMkTDkhDaZwX5lbq/5JHlyU0
         X8mD7hpKC2efx1g9fazg+pQsJ9QjFE0o6W0Twzy8qF8ozkT9ku4BFwnJvu4IZ0dkq9u9
         AaACILdDWKGhWmL9WSuulUbyajN9h1CFuGUvw1YD48OrUi1ILgJ0qrLFCQhtuHwb1HuT
         ywWPCQ2bHyjqjUANaLRfxoGoZ+KPBORXWb241RlD+sGeom4bsWzHD4TYzqzwhdqWZsuq
         X9xg==
X-Gm-Message-State: AOAM532q7qxI1dHW+B7aNf6sbiv9P3tV14n9ke8GxfMgi04QIYGYlqlx
        bf1BxGl3ou86LXdnEyxp4/g=
X-Google-Smtp-Source: ABdhPJwqHs9nH5lpOjXcb6/qKvV0pCQNXS3T+Kk1mOdvii1ND6yeM2aFqKeCAbxHGyh62D14O+e0lg==
X-Received: by 2002:a17:907:8a19:b0:6e8:a7e:5f50 with SMTP id sc25-20020a1709078a1900b006e80a7e5f50mr12871020ejc.322.1649327461054;
        Thu, 07 Apr 2022 03:31:01 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:00 -0700 (PDT)
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
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next 00/15] net: Remove use of list iterator after loop body
Date:   Thu,  7 Apr 2022 12:28:45 +0200
Message-Id: <20220407102900.3086255-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
two patch sets, where this is part 1.

Link: https://lwn.net/Articles/887097/ [1]
Link: https://lore.kernel.org/linux-kernel/20220217184829.1991035-4-jakobkoschel@gmail.com/ [2]
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [3]
Link: https://lore.kernel.org/linux-kernel/7393b673c626fd75f2b4f8509faa5459254fb87c.camel@redhat.com/ [4]
Link: https://lore.kernel.org/linux-kernel/877d8a3sww.fsf@intel.com/ [5]
Link: https://lore.kernel.org/linux-kernel/20220403205502.1b34415d@kernel.org/ [6]

