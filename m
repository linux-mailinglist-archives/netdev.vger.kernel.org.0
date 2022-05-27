Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8498536929
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 01:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355166AbiE0XVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 19:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiE0XVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 19:21:52 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0556B020
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 16:21:50 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2351C3FBF5
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 23:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1653693709;
        bh=jCJRIuwasAhvH1GfxFr/jSUssAbDIpq3esy7eIKm5yY=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=IFpHfdjNa7ha+HZUhKZoNwUXjkYD2UH1fRAPMw3yHPztIGRGFgUeAMeVdmywJWJNP
         hMOSk0vDuJBV77Um7t/WkMAB274pJpG1vz/MAAYM//8iHcRNNLSusWJDjMhPrW/yCt
         8ujpNUv6HcJdDODCMeKzsCWaH3stHvEw9wdblvNyxRqVt01ezui8Cgsn985hDQppDq
         9aWl7MLcvGEQx5yeDoKeQCKWcydHijIemG0+lTqOC4ne//1hu9CgFHBJiSRjY5uVMn
         OJk2mLHGDISaxQhbhhwdUBeCuzvRRdHNK9lrRYuuODxDrRePEIxFbKWPP0k1nvjXcd
         eZJ0sd0SYQdaw==
Received: by mail-pg1-f197.google.com with SMTP id t14-20020a65608e000000b003fa321e8ea3so2771600pgu.18
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 16:21:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=jCJRIuwasAhvH1GfxFr/jSUssAbDIpq3esy7eIKm5yY=;
        b=w2wsBpZNfueRQkJi9yEygOE5DoU8AX3HYNdBCuKp5Pdv4Dvkeukkil0oGQTAStlabC
         76kIH82LXhhDJYspyZp0J8HTcsmqCFqmdeeS6B3lCqh0lhGarlXTSjW4kO0fAjBsPpDE
         rq4w1byAmaclHmaUqXeCy2gmQAo63TFWNqnvQcIZijmTKDhhfUK1DfqU6EwZRgoUJoUY
         lvoCKnLzMd9chBLyra2pUGHVKXvHglSoBuVU6nnEqosIdYs678g9eVWpJiiCaXR1erEY
         zkjFml4oHB6jeVni4UYCkIqLW+Ho/of4oZH4YHL6GDmjkzXiwe/queuYPdnBqwZa+KWN
         xOgA==
X-Gm-Message-State: AOAM530a/tmo0nMzn0yxNJkZdQr20VUM8yPGo3mzDKgY1AQRmVuOOW/D
        UXlmgCyFfoGbiRRcBZk188wjG9stATZBDE8nGgtdQp8cWmYw9GFZ0D5xfPv2lGcEpwSYqg459uj
        9XMRj+WORU88ryoopGXF41RHy8B/3PncKtQ==
X-Received: by 2002:a17:90b:4f47:b0:1e0:5156:c7ee with SMTP id pj7-20020a17090b4f4700b001e05156c7eemr10586735pjb.87.1653693707053;
        Fri, 27 May 2022 16:21:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydl2P0QGTEzTuRafeDfbl+AvHzL95LFvn4A9XX/pE7hUEAPzxjw0P+IhsedB1brtwqYaygdg==
X-Received: by 2002:a17:90b:4f47:b0:1e0:5156:c7ee with SMTP id pj7-20020a17090b4f4700b001e05156c7eemr10586711pjb.87.1653693706761;
        Fri, 27 May 2022 16:21:46 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id r14-20020a17090a940e00b001e0abbc3a74sm2155185pjo.5.2022.05.27.16.21.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 May 2022 16:21:46 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id E61AD6093D; Fri, 27 May 2022 16:21:45 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id DF0C2A0B20;
        Fri, 27 May 2022 16:21:45 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] bonding: show NS IPv6 targets in proc master info
In-reply-to: <e09cd8cf-4779-273e-a354-c1cfba120305@redhat.com>
References: <20220527064419.1837522-1-liuhangbin@gmail.com> <e09cd8cf-4779-273e-a354-c1cfba120305@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Fri, 27 May 2022 10:13:08 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18038.1653693705.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 27 May 2022 16:21:45 -0700
Message-ID: <18039.1653693705@famine>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>On 5/27/22 02:44, Hangbin Liu wrote:
>> When adding bond new parameter ns_targets. I forgot to print this
>> in bond master proc info. After updating, the bond master info will loo=
ks
>                                                               look ---^
>> like:
>> ARP IP target/s (n.n.n.n form): 192.168.1.254
>> NS IPv6 target/s (XX::XX form): 2022::1, 2022::2
>> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
>> Reported-by: Li Liang <liali@redhat.com>
>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> ---
>>   drivers/net/bonding/bond_procfs.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>> diff --git a/drivers/net/bonding/bond_procfs.c
>> b/drivers/net/bonding/bond_procfs.c
>> index cfe37be42be4..b6c012270e2e 100644
>> --- a/drivers/net/bonding/bond_procfs.c
>> +++ b/drivers/net/bonding/bond_procfs.c
>> @@ -129,6 +129,19 @@ static void bond_info_show_master(struct seq_file =
*seq)
>>   			printed =3D 1;
>>   		}
>>   		seq_printf(seq, "\n");
>
>Does this need to be guarded by "#if IS_ENABLED(CONFIG_IPV6)"?

	On looking at it, the definition of ns_targets in struct
bond_params isn't gated by CONFIG_IPV6, either (and is 256 bytes for
just ns_targets).

	I suspect this will all compile even if CONFIG_IPV6 isn't
enabled, since functions like ipv6_addr_any are defined regardless of
the CONFIG_IPV6 setting, but it's dead code that shouldn't be built if
CONFIG_IPV6 isn't set.

	The options code for ns_targets depends on CONFIG_IPV6, so
making this conditional as well would be consistent.

	-J

>> +
>> +		printed =3D 0;
>> +		seq_printf(seq, "NS IPv6 target/s (xx::xx form):");
>> +
>> +		for (i =3D 0; (i < BOND_MAX_NS_TARGETS); i++) {
>> +			if (ipv6_addr_any(&bond->params.ns_targets[i]))
>> +				break;
>> +			if (printed)
>> +				seq_printf(seq, ",");
>> +			seq_printf(seq, " %pI6c", &bond->params.ns_targets[i]);
>> +			printed =3D 1;
>> +		}
>> +		seq_printf(seq, "\n");
>>   	}
>>     	if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD) {
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
