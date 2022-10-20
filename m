Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4FD6064BB
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiJTPgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJTPgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:36:49 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66A41DDDF4;
        Thu, 20 Oct 2022 08:36:42 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id sc25so320141ejc.12;
        Thu, 20 Oct 2022 08:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qPwKKOSL5o3iKP3/dq2Q/Xqf5eS+OyCN/8/d6oWiIbo=;
        b=Wez6UWR4yVy7ljjWDwKmXH6VNrw+c4JqEj+dW/C4iE13oGKDcKlajUuNqxj6oLepyi
         C0skbvziSspULzvlwn8TBGB6Tv1ygZ83Nk9yz7CmVwEt93bAqdM1W+mP5lRva/Mu2sfA
         wUJ27HWB96G1EoRapxy1zVd0dSfec6ORQh0UyIB4LVjAyzUCUXaiRRDCLvVFoEQ8Rdxg
         Ub7Q/WvBLNLViJ6sWzK+Oz8/bF7ofcwRMyWfFsvy2ESmkC+fRO+XYiQFfPUaUZI46ja+
         kaaUkAOdxxOythUrOTUZPvVTZDJCnY2dlbASFAtPDOc6Xi/cXW/qf28qa4TWVPqSRx7W
         vAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPwKKOSL5o3iKP3/dq2Q/Xqf5eS+OyCN/8/d6oWiIbo=;
        b=lc+2uXgcpmuEkZFec6auGFbaAMddyJSp4+fis4Mvfe2kmVCwJvyHd7oJ7KjQpOkhTB
         IUvu1sqAnVyp+uY8357N6dv04DZjNkqn87stIjVFcVa/OaZ81Ng9faEN1jHp6V3dUefR
         p2oXFWda42zjA4NJR3I7QDWASTJkVr/ST6Rx1eynOoPgo2fXs73p/tBDbwBk5WIv1S97
         c+DIgcBLGHZmYWfZVtVqaElsl25/9FqA2Gtb16VqO8WLk9YIoiu53Ox6I+i2519F29Yf
         6SRCh/BnvO7OSAGBjpbxqhlrCsE2uL2P9OaNzs4X40d8hbvoLQNkt6yIN4qjPRC97WA2
         Ul2A==
X-Gm-Message-State: ACrzQf1zOsu9nGVfnXeKENWiHSrxOfPzz0jtf9v0bBwqlEMxXptGqEIP
        9jTAZX1CDmY4s/BadptMJDI=
X-Google-Smtp-Source: AMsMyM5s+eomvicrwy06vylV7JHYWUXt7SptVI0OJ04clH7AsmxgYkS4j30ouF2cBsqK3IsRWpsFNA==
X-Received: by 2002:a17:907:724d:b0:78d:acf4:4c57 with SMTP id ds13-20020a170907724d00b0078dacf44c57mr11472630ejc.516.1666280200876;
        Thu, 20 Oct 2022 08:36:40 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id m13-20020a1709061ecd00b007305d408b3dsm10388170ejj.78.2022.10.20.08.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 08:36:39 -0700 (PDT)
Date:   Thu, 20 Oct 2022 18:36:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 05/12] net: dsa: propagate the locked flag
 down through the DSA layer
Message-ID: <20221020153636.ceqk67hmut3govsp@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221020130224.6ralzvteoxfdwseb@skbuf>
 <Y1FMAI9BzDRUPi5Y@shredder>
 <20221020133506.76wroc7owpwjzrkg@skbuf>
 <Y1FTzyPdTbAF+ODT@shredder>
 <20221020141104.7h7kpau6cnpfqvh4@skbuf>
 <Y1Fn+TnbI/uMH0VR@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1Fn+TnbI/uMH0VR@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 06:23:37PM +0300, Ido Schimmel wrote:
> 3. Miss. FDB entry not found. Here I was thinking to always tell the
> packet to go to the software data path so that it will trigger the
> creation of the "locked" entry if MAB is enabled. If MAB is not enabled,
> it will simply be dropped by the bridge. We can't control it per port in
> hardware, which is why the BR_PORT_MAB flag is not consulted.

Ah, ok, this is the part I was missing, so you can't control an FDB miss
to generate a learn frame only on some ports. But in principle, it still
is the BR_PORT_MAB flag the one which requires these frames to be generated,
not BR_PORT_LOCKED. You can have all ports LOCKED but not MAB, and no
learn frames will be necessary to be sent to the CPU. Only EAPOL, which
is link-local multicast, will reach software for further processing and
unlock the port for a certain MAC DA.
