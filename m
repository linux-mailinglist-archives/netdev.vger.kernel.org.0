Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E675124E9
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbiD0WDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237893AbiD0WDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:03:02 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCA1266E;
        Wed, 27 Apr 2022 14:59:50 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id f2so4430163ioh.7;
        Wed, 27 Apr 2022 14:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EJsiHNT79VVIpSJIQf2oGVX7izbgw/olktUMj/NaMvc=;
        b=N1VpsMpbaf/hvl2UnUGsTbZFOFYoUjP06knRAnAgXss1kHjQv9DSXlsZARkKqGWK2W
         LkVNJy0RI2Rv9p8pb5plc9F41GPWOqADNsRzmdhmeT32cNtfflsOCvm7PoLTIeN4/88e
         TEkuZTyTQ2iiwFb2I6V5y5YF3HhlXnhpwuvqit/Lt/kYSzQnJTNY605twOJkA/3qzKIb
         VQf1KVD5iO2Fw4oD0FgMIc/nN2fmiVCXo7o1GTkOrwW/6kspwAJtI/bhqhG2q5AQvwxJ
         MwB5EZWsHYaL1PIt3Vzmy3pUw6xia3k5oyqLAgkpFfOq5Q5z3WumaXbJysSAzZAkkQal
         K7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EJsiHNT79VVIpSJIQf2oGVX7izbgw/olktUMj/NaMvc=;
        b=dx3YyUGnD5SIxDeqk63wrC6JdCAOgiaMKlsUVGBHuBAbJ6x2V68r+EP2nf71DyIvd/
         dNO8Nw4d1kJVnJol71KDoK54xohvdP5maqYyf5u2JtoM+G0RJQnFL+UW1MstX95gvH/t
         lKU/2fNyVcxc6vctMlQ2JJ5ZXNPklHh3IR6Y0Ff0nr7ucOAK/KbmdDuTmusz6kZIGrFV
         Hn1PhZ3kCybY34ye1WW6mK3sHDrZOwMhtK7EOmzgVWRoyiNknaSYk7Z39quvoVt+cbHr
         OrcjTnJ8SqTw/ZHlr1TpvLO21CZrM5jzbbSSqvQLiDzYhQ+lkaIE0WGlEweWSUalDSFK
         RsHg==
X-Gm-Message-State: AOAM531TAcFXclNh7ixTnjj63V2hPrfomcLFQ4lb/mATdVvfnppv42vm
        r9uVyA7xS0TuMoBzSdLpVrY=
X-Google-Smtp-Source: ABdhPJxTacxkkTRZyyS7nw+N/2vdrFweOc1WoIrlB0dTFr39gYnqo9LBAO8iPDtqPG1+DGP6CYAqWw==
X-Received: by 2002:a5d:9316:0:b0:657:a364:ceb with SMTP id l22-20020a5d9316000000b00657a3640cebmr4232073ion.63.1651096789907;
        Wed, 27 Apr 2022 14:59:49 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id r63-20020a6b8f42000000b00657b2837880sm2004154iod.30.2022.04.27.14.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 14:59:49 -0700 (PDT)
Date:   Wed, 27 Apr 2022 14:59:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     liujian56@huawei.com
Message-ID: <6269bccd77ead_d9e8d20820@john.notmuch>
In-Reply-To: <20220427115150.210213-1-liujian56@huawei.com>
References: <20220427115150.210213-1-liujian56@huawei.com>
Subject: RE: [PATCH bpf-next] bpf, sockmap: Call skb_linearize only when
 required in sk_psock_skb_ingress_enqueue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> The skb_to_sgvec fails only when the number of frag_list and frags exceeds
> MAX_MSG_FRAGS. Therefore, we can call skb_linearize only when the
> conversion fails.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---

Looks good.  I guess performance improvement for some use cases with lots of packets that
no longer need linearizing must be fairly good.

Acked-by: John Fastabend <john.fastabend@gmail.com>
