Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62220503800
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbiDPTlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbiDPTlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:41:12 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46393123B;
        Sat, 16 Apr 2022 12:38:39 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id s14so9535310plk.8;
        Sat, 16 Apr 2022 12:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1Od2+V3Bj00Er4Mva8kO5nsmL4Z8o4xlw5ojaMLjb+w=;
        b=FFOQGdsSjPmsDdXIlaewKQ8ZFhhoraD8wn0k1G/X2hv94hq9geZz81UYFVS4QYEjw2
         btSOypwjHN5ovugpJYXXuzgZu9we+zRymba667F54uMiM4CMybbNf4RHA5IWRYHtsNMT
         F5YBX+bTf6CoSIKm+3JVthY0Cchzo9cOliLZ01HWHYAX59s02cO9El5NZakqvkNABfSn
         lkszACXmfnj9J5YZIp6tae1eh1D8pLBHppOwp9JcmCIjSyQ0HwlBy5N6bdR0Mtnpxj54
         XAv9mbIWjOYBnR9di3tXENZ1YPh5wbAYUNUVVx8cvR74hs4VGWCyH9sxSPQ2MZF+HxoH
         XcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1Od2+V3Bj00Er4Mva8kO5nsmL4Z8o4xlw5ojaMLjb+w=;
        b=Gv5UKyFWOyXm9zh5IcxH94rL4uPDJK8UZx4gjSRxqvIDXGaxKfrfeLkK31fb0DkDTv
         7hIq/uEjspugdHGiUYEADmkIHgZHTMlWb3FaDRYC6ZoIs5c/7c2MzSIwXL6/P3lXbT+l
         rimddvgWvJODOmvQflyJe2bfsPDUFnNCuplqQTDaJth7difxNrdgmfq5K9KybDM5HhD2
         B7dDbrJqbqmHZ5YX5w6fRFzLvIYnBMu9y1d274J2DpFc4ASrVMSbrBNICD0Uc2Klc5OB
         VE5N+gBd0es4kGdnvq2OEHRLYpXm6GPrzwiufDkrG9cthzzKfx9/ZONkfENMPGh/mdGm
         yVKQ==
X-Gm-Message-State: AOAM530aFoinvX5R6WBqiGYdvovwzBMVAkfgW646oW5TgVUxBg1SAXRI
        MUNP1E/ndEpi7uRQTgqEqMg=
X-Google-Smtp-Source: ABdhPJy7mlYg2xknqTc8SqONg+1saF9q0f2T6nu61MenY84/BMYT2pB1OyS1ut0gOcOlm4Mvl8AMzg==
X-Received: by 2002:a17:902:ccd0:b0:156:7ac2:5600 with SMTP id z16-20020a170902ccd000b001567ac25600mr4631387ple.156.1650137919166;
        Sat, 16 Apr 2022 12:38:39 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g15-20020aa7818f000000b00505ce2e4640sm6678733pfi.100.2022.04.16.12.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:38:38 -0700 (PDT)
Message-ID: <64a9fc32-0288-d142-f35b-0f688a0a6659@gmail.com>
Date:   Sat, 16 Apr 2022 12:38:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v4 06/18] net: dsa: mv88e6xxx: refactor
 mv88e6xxx_port_vlan()
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
 <20220415122947.2754662-7-jakobkoschel@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220415122947.2754662-7-jakobkoschel@gmail.com>
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
> To avoid bugs and speculative execution exploits due to type-confused
> pointers at the end of a list_for_each_entry() loop, one measure is to
> restrict code to not use the iterator variable outside the loop block.
> 
> In the case of mv88e6xxx_port_vlan(), this isn't a problem, as we never
> let the loops exit through "natural causes" anyway, by using a "found"
> variable and then using the last "dp" iterator prior to the break, which
> is a safe thing to do.
> 
> Nonetheless, with the expected new syntax, this pattern will no longer
> be possible.
> 
> Profit off of the occasion and break the two port finding methods into
> smaller sub-functions. Somehow, returning a copy of the iterator pointer
> is still accepted.
> 
> This change makes it redundant to have a "bool found", since the "dp"
> from mv88e6xxx_port_vlan() now holds NULL if we haven't found what we
> were looking for.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
