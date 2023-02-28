Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634486A58BA
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 12:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjB1L6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 06:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjB1L6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 06:58:51 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB0E2410A
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:58:50 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id d30so38833889eda.4
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EDSs4KY4x1JAy+0g6ZKx4tW3fb6V0mBeClHVx8SlcW4=;
        b=o1kllUm4vUkwaCGGd2dzpNZEMP0Uk+bO4ntVJ5vOxcIUkBCzPT/mjtLQQJ5Dw5+UFi
         xqf9t991MfXbQ+4cEe2Bu49mYSd9x9Vl/Bmby9xgfnsV5nFwmODEXka8edK4JFcNy/gR
         4UrQMczLR6e7QuY4fdAiFHNmeH6xGBKRSrZ4Iwc6hSJWxbQCLB1u+7xEDirWyFpv2bIO
         232fbvAJvQG8lifEj8X1eTgJ16x8yXKwpevh7FpPA/MteJSfoE4j7OriGQCEPMSEi/np
         5kQXLqrmHn6cmVnYGI3ng39VDP19cw6imUBRu7GfwNS1cdr6luNz12D5eNiFzIR9Xhye
         r21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EDSs4KY4x1JAy+0g6ZKx4tW3fb6V0mBeClHVx8SlcW4=;
        b=GEL44AbevP8D8CoOD3I8/Xac3EIryajvz1cqr8NZaYp4JOn6CCFfizcXFpnb8SvJNU
         NkyEzcCSz06mqhpp3POT/MVJUYQzwcd+liFeF2vm8GaGI9CKnL7hQg5G7EowCTdi0SqK
         ZosPDsImWnejYvMAQa3Xvs6K/ml6fA/J1tsjo9cad1GwbrjXmihe2V3wT/WgSwc50lOv
         l1b380PwPbiOuUdsVUbba0Trv8kW/X/6I4K3w4J/pD/1gP3xblawkhfRqx5T2qWWTCka
         Ygw9mgHvUsUtCaZgMwmDVHcUj4dRXaUiGzl3R+fMOykt6vh7Sm+QyTRgXk1nMJ8uK0Vs
         CDeA==
X-Gm-Message-State: AO0yUKV5vPhhuRdWl03w417JiXRhcQkIe2YKKMg4UL14Q//V7rrQHVQK
        YJ9+u5GGvnr8o+oEDcW1kJY=
X-Google-Smtp-Source: AK7set/t70qn5UHKvy+SWelkHFbQtaU8gQlkEKeQm1Ra9t0dkEdZKcViXkevZfQpr7e1pLC3PnP/lw==
X-Received: by 2002:a17:906:b849:b0:8b0:f58d:2da9 with SMTP id ga9-20020a170906b84900b008b0f58d2da9mr1812697ejb.64.1677585528680;
        Tue, 28 Feb 2023 03:58:48 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id mj22-20020a170906af9600b008ba365e7e59sm4415576ejb.121.2023.02.28.03.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 03:58:48 -0800 (PST)
Date:   Tue, 28 Feb 2023 13:58:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
        erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230228115846.4r2wuyhsccmrpdfh@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 26, 2023 at 01:12:04PM +0100, Frank Wunderlich wrote:
> but back to topic...we have a patch from vladuimir which allows
> setting the preferred cpu-port...how do we handle mt7531 here
> correctly (which still sets port5 if defined and then break)?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n2383
> 
> 	/* BPDU to CPU port */
> 	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
> 		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
> 			   BIT(cpu_dp->index));
> 		break; //<<< should we drop this break only to set all "cpu-bits"? what happens then (flooding both ports with packets?)
> 	}
> 
> as dsa only handles only 1 cpu-port we want the real cpu-port
> (preferred | first). is this bit set also if the master is changed
> with your follow-up patch?

Could you please make a best-effort attempt at describing what does the
MT7531_CFC[MT7531_CPU_PMAP_MASK] register affect? From the comment, if
affects the trapping of control packets. Does the MT7530 not have this
register? Do they behave differently? Does the register affect anything
else? If that logic is commented out, does DSA-tagged traffic still work
on MT7531? How about a bridge created with stp_state 1? I don't
understand at the moment why the hardware allows specifying a port mask
rather than a single port. Intuitively I'd say that if this field
contains more than one bit set, then control packets would be delivered
to all CPU ports that are up, effectively resulting in double processing
in Linux. So that doesn't seem to be useful. But I don't have enough data.
