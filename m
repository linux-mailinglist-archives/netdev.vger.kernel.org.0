Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F05D61929B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 09:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiKDIS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 04:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKDIS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 04:18:58 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE82026566
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 01:18:56 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CFA3342478
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1667549934;
        bh=3fL7maUHhP2+RkN80i+vtowxXIrv4SdCbi8OSTTikZA=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=TOOh7BaSZ/YXdJJc4/vSE7d7Z165UXQjwa225Kd7okGpURMJABYeHMeEIUaoZ/iRd
         kdjLZGspIPBcZ8WM4xwcKfP+INZ436ZWji+FNktMiMvGGTpCdNF0hG/HFAA2gNjn0J
         8x4Bv3vryAwwUH6CYVWJ8nmbMFHO8/vDn47NJY5V9fUFXE/osm+CN5EuHq2RAkreVl
         SqbhWgABOc2SKwBcUL9QGhjSSFoqJcSMC/CVCJJniS+OSeGYTKLygaofrdSRHQrwuz
         FTi7zbJ2asfZ10o/pAiA+QplhYe0rPnwXZB27iC9PQI72k5CZxs/NN209X9k3/8Nov
         QGh2nK09k/jlw==
Received: by mail-ed1-f71.google.com with SMTP id y18-20020a056402359200b004635f8b1bfbso3002349edc.17
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 01:18:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3fL7maUHhP2+RkN80i+vtowxXIrv4SdCbi8OSTTikZA=;
        b=uVHqjz9+lgbGk4Y2MfKl3w8Q9x893DwunV6PIWC6Q3yo6jrtv833ix7Pu7a3SL6V+J
         pdthv4vQIbfSZjrggs5kFXakRj3n5ZHTWHNgiugkRsti4uTaJ+T7NMnqwvJYT6CL7ZrC
         jvROzwweXJJeQ5JjUdtvLdZ/wMOTntNAm/j8jDSTfk1ckEKbhZJUdtctYCbP5N23GsbV
         7OUHCdaUzxTH+t3XgatbpAq167hBsJlq4L+Br1K3MmIlH1CA68H0huxArFxmfw7CbJ0U
         /lrbfACWt+M2qmVfVlrwrICfI8cY1waZhnOIqfIkP8JD0iYkSRYz68K8n3lgG/+1niWq
         bsTA==
X-Gm-Message-State: ACrzQf3LXuLfdxYKFUheoHBrZHYAvmHD6zLZCXm7y18INxbtyXJxRmdP
        3u/9gGCPAXAPtvfPq5rpDfXzzdL+VVJV4nJMKqs2CLCki3PsdQXi24p98Uz4ys6dvFLShSHX14G
        Du3YqEUwIovoEo2Q67MSWYnMt8TglZ3VKrA==
X-Received: by 2002:a17:906:7948:b0:7ac:d6f9:eb3e with SMTP id l8-20020a170906794800b007acd6f9eb3emr32357955ejo.350.1667549933952;
        Fri, 04 Nov 2022 01:18:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM58vdbOkawz3z7dkYT4yfSesYWz4vfYlsxdZg8xVmtTFYFpAFROKk8quBx34E1h/5jGjqHw+g==
X-Received: by 2002:a17:906:7948:b0:7ac:d6f9:eb3e with SMTP id l8-20020a170906794800b007acd6f9eb3emr32357934ejo.350.1667549933769;
        Fri, 04 Nov 2022 01:18:53 -0700 (PDT)
Received: from vermin.localdomain ([213.29.99.90])
        by smtp.gmail.com with ESMTPSA id vs8-20020a170907138800b007a559542fcfsm1493631ejb.70.2022.11.04.01.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 01:18:53 -0700 (PDT)
Received: by vermin.localdomain (Postfix, from userid 1000)
        id 8D1D01C9B0A; Fri,  4 Nov 2022 01:18:52 -0700 (PDT)
Received: from vermin (localhost [127.0.0.1])
        by vermin.localdomain (Postfix) with ESMTP id 8B2081C9B09;
        Fri,  4 Nov 2022 09:18:52 +0100 (CET)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
In-reply-to: <Y2TIeiI1s+hdBPlL@Laptop-X1>
References: <20221101091356.531160-1-liuhangbin@gmail.com> <72467.1667297563@vermin> <Y2Ehg4AGAwaDRSy1@Laptop-X1> <Y2EqgyAChS1/6VqP@Laptop-X1> <171898.1667491439@vermin> <Y2TIeiI1s+hdBPlL@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Fri, 04 Nov 2022 16:08:26 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.7+dev; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <182264.1667549932.1@vermin>
Date:   Fri, 04 Nov 2022 09:18:52 +0100
Message-ID: <182265.1667549932@vermin>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Thu, Nov 03, 2022 at 05:03:59PM +0100, Jay Vosburgh wrote:
>> 	Briefly looking at the patch, the commit message needs updating,
>> and I'm curious to know why pskb_may_pull can't be used.
>
>Oh, forgot to reply this. pskb_may_pull() need "struct sk_buff *skb" but we
>defined "const struct sk_buff *skb" in bond_na_rcv().

	Perhaps you could use skb_header_pointer(), similarly to what is
done in bond_3ad_lacpdu_recv() or rlb_arp_recv()?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
