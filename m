Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55AD660E5E
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 12:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjAGLl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 06:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjAGLld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 06:41:33 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446A18BF22;
        Sat,  7 Jan 2023 03:40:58 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id u19so8934197ejm.8;
        Sat, 07 Jan 2023 03:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JMSRRrPsfEf7awyXGfuq9l67gOymxzXz3Tf7FKYlHfI=;
        b=JGcs3K4qSnIU3pfuiO90jtu8ySPovlahJx4VdhIQiim04sm5qQ+lCDca4QUgKWgW9j
         uimf7RXU7KtOunei4A+vJuK0eRAUaTzWfArHLOrLIjt5CjUMHF4GC9Yb7jgJrZ80W/iX
         e46CpmZiJGf36ptENRPY7v6z5F4SotraE6XfOKC9QCZ19fKgvIEgiNGGGm3fmF3AsHKr
         N9zp4iuapMmLtGzFsYkiVYXE4WSdnZrs+Smo8RHS+eoAXwc/shVc/DmpTxN6DDFkusQ5
         oYU8oGjhm43/deHOZgApV0d/VJDTJvXbF/xa6MRV6y21mNhUX60FEeuVWM23StYH1bSS
         kHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMSRRrPsfEf7awyXGfuq9l67gOymxzXz3Tf7FKYlHfI=;
        b=ErDg2Eiv7Lau0fInrO1NdvQCN+mkduhSGAXVdl2TZ/qpRzgq0fVR8C+MNRqox46WJl
         ZnYHHO68CZ3p444WvKQE3sLTVKT9UPlYT8Tuz8okiAPb3Elf/P5brVhOPbnelsX6kx7T
         Gyeve++X7CEZ1PAhGU7ChQWjwBDUF35ZI0ZkrcQqrOhP9DDYl3d9ORlMiT7DLK2u9n37
         z4h4AU8i0qpsNcrwiD4LAy90b1BGCdNIICokFp7TCmU5k3ZI5qoMA2rLQ7+rx3SQf/Rm
         /0GsJw0dY3iWcsduAXJH9G6HtAjmeaPz+4IB8GEmsVZSPLQBBThnimo0O1PSIpCPmTpF
         71Sw==
X-Gm-Message-State: AFqh2kqUdKY6rq7AP9Uhwkn96AaeAodYTEIAWUccTewl1aNs/kg/UsaT
        DHRf2Ir58P7TW9vzupSVeWhta1N6ps8=
X-Google-Smtp-Source: AMrXdXt9tIpHkPU9sCZcPlsUsMNJ1guGQBeCgjV35LmXWZ0skNIQnWaiiBLmHOeBwolybbHPMrpKXQ==
X-Received: by 2002:a17:907:8b11:b0:81b:fbff:a7cc with SMTP id sz17-20020a1709078b1100b0081bfbffa7ccmr49996920ejc.18.1673091656833;
        Sat, 07 Jan 2023 03:40:56 -0800 (PST)
Received: from skbuf ([188.27.185.42])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906301500b007c0985aa6b0sm1359241ejz.191.2023.01.07.03.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 03:40:56 -0800 (PST)
Date:   Sat, 7 Jan 2023 13:40:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 2/3] net: dsa: mv88e6xxx: shorten the locked
 section in mv88e6xxx_g1_atu_prob_irq_thread_fn()
Message-ID: <20230107114054.i3mnzh32gvkiw6fr@skbuf>
References: <20230106160529.1668452-1-netdev@kapio-technology.com>
 <20230106160529.1668452-3-netdev@kapio-technology.com>
 <20230106163759.42jrkxuyjlg3l3s5@skbuf>
 <540e6577f028c05c8ea39c2a09bce23e@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540e6577f028c05c8ea39c2a09bce23e@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 10:44:33AM +0100, netdev@kapio-technology.com wrote:
> Can I fix it and resend the same version?

From my perspective, yes. But not sure what you mean by "the same version".
It will have to be v4.
