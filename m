Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2616503804
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbiDPTlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbiDPTle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:41:34 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D723152B;
        Sat, 16 Apr 2022 12:39:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id be5so9512475plb.13;
        Sat, 16 Apr 2022 12:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=N+DA4t8WHVTUtbydzYgACjP/GeP+iQmNsdDutAJHeuA=;
        b=ipkj2w+o4JXJ3KVPO0DxLQWuqs4OEyi3UxINeXoIACCYu6fi6SkJQHqTkrYwYGprUQ
         eFmI7HinPBK1VOkYjtuvYxcz0o+axmOWFuu05Ikj/TH1PrTl1EbSnsUo0T8FWlF4ucXj
         UIdtITPmr4CiwPguZXFmrLHp1mzUxubJ2PQLWe91Zk2tpcpgQRCgqJsfRW06Go+ljivI
         D6CuHcdtpbXh1GP7kTxAbofHF6QwSBpbAIYYbNPw9ms5N9bglUTEtjE5UD7rXrParXGc
         kZzuK5gHoSIDFJqFGQlftcu7Dut1Gv5ZlsMOVF1z39g57L5NEGalhGUQoG6dehteKE89
         HYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N+DA4t8WHVTUtbydzYgACjP/GeP+iQmNsdDutAJHeuA=;
        b=GBR1wGUJBeui+N5CdhUPpC0uQxK/2oGomJY22y+6+ippRuJKlGYO20NeP8o9JnBwDL
         s5wkSwqRgGPRvY6Ey0LHS/vNTx7gLWpKdaAn3ETQNKXcHBCU8v9vewMgSxs5yVEt0oKc
         f6b5eLb5/9aPBel7uHQNLeQXvTP0+XWOJYKVWMulFTObDlYV9dxyZopNBeIDn6f6k3g3
         SwTi9LhzLToTq2Y9MLcsDfmxV9RmgFtVLKBwlCwPQoJdQvRWR8xMvblTRoMB9WhjKQhV
         71sfhEvFp0q7ucuLgV4J7jKqzBdb5fRf5zZqUAZGU3eSE3FE+6oamdctU8m35xiJKV4d
         F0Pg==
X-Gm-Message-State: AOAM533HG4nIDqzGkdhmQ7a4jV1Lyn4DmJbjsvH//tWykmGQz4Lfo5vI
        LuNirI0qoH4pE0vUo6nXSWU=
X-Google-Smtp-Source: ABdhPJyeyAQ30+cHYCLhpzgXBLBNZ+Oa9HOuk6mMsnj9uqD+miynqPFri5VlK2WPnuSq25kcoNNBeA==
X-Received: by 2002:a17:903:11c7:b0:154:b936:d1d4 with SMTP id q7-20020a17090311c700b00154b936d1d4mr4694779plh.78.1650137940950;
        Sat, 16 Apr 2022 12:39:00 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a0023cf00b004e17e11cb17sm7142471pfc.111.2022.04.16.12.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:39:00 -0700 (PDT)
Message-ID: <2c0e1778-4602-67eb-8481-33e29764c84d@gmail.com>
Date:   Sat, 16 Apr 2022 12:38:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v4 04/18] net: dsa: sja1105: use
 list_add_tail(pos) instead of list_add(pos->prev)
Content-Language: en-US
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
 <20220415122947.2754662-5-jakobkoschel@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220415122947.2754662-5-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2022 5:29 AM, Jakob Koschel wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When passed a non-head list element, list_add_tail() actually adds the
> new element to its left, which is what we want. Despite the slightly
> confusing name, use the dedicated function which does the same thing as
> the open-coded list_add(pos->prev).
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
