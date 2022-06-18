Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF0D550231
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 04:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiFRC42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 22:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiFRC41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 22:56:27 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DBD6C0DE;
        Fri, 17 Jun 2022 19:56:26 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r5so6248046iod.5;
        Fri, 17 Jun 2022 19:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=U3HYhcyZNnttgoB9WEg09gKNhxYsBxK1b2GJ8pko3jo=;
        b=q3YXVZK1V+ZKf9XoYjL0CJenOHwGlaV2tLHyu0EM0PBKaa9PwQJupJ+b2nH3zTzZcM
         r+8CDtQV7+QByJOkvpnFRtbRC1DHPhVxtZOhUlJiTz3hvK7M8hTwR58IvfYGg2l2rWv4
         Uh9CiJ/ViRModq3K0Tkyu6mf360ynZwQgXWARY7lpZdFWxV0Fv/+IAO3fiZgr1llurqR
         7sevZgpxNQ22l+L5E0Bdw/B2JA2uPm9vny5QuY9MIxsB8d8ayKrzidTfqSUQ5Emj+RHw
         CsVGJB24QK2bqVtjAZPGmKILWclIjVMgELJNpOz1gS9mqPPAU3ZklOYe4VPyrgJ/pya5
         fEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=U3HYhcyZNnttgoB9WEg09gKNhxYsBxK1b2GJ8pko3jo=;
        b=xdnznTvD8cb6Q7Q/wch1gvtZZy5aVGokTE9mVEf7u7tg0+ovG4V9EOHxk0VSjs37Eu
         GDkUvhPjKI0g0B6QvtqpPrnZwlxKkdQi5s23wfJggAkJ0BREfFPHmiQPQ/83s8cNpuIr
         aziixqX/Xh24mUXippYtHZW+9fGn+kh7acYWgIEewgTcgit9YzKs4YU6le+rxEXrlZCQ
         8Lui/q40be1HSHc/cjuCes2mreRxkcrJZiOZYP7zhp706LQ7a8hBJoGsBYjUvlhx13BF
         Wu72RQcqh5VjpnjzJMifG4XFn5SCKoHz+603AL5QaQ1YWavPcgZ+JsBcM91mH4SoOFeu
         K6vQ==
X-Gm-Message-State: AJIora/M2Eiut8Q0L1LAdqI+uGSqaOXF5tOPILqbsVVsJXmbmFat+6S4
        WTgC7cbkwPkqFGaQPQdjuUc=
X-Google-Smtp-Source: AGRyM1tdSUFbHu2XQbPnq8+CMVDe/ehv6Yq1BbOK0I9xHGfK5hSVXgFpALKgmkX1I19EJX9BM76sxg==
X-Received: by 2002:a05:6602:2b0b:b0:64f:acc1:52c3 with SMTP id p11-20020a0566022b0b00b0064facc152c3mr6452194iov.38.1655520985707;
        Fri, 17 Jun 2022 19:56:25 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id 10-20020a02110a000000b003316f4b9b26sm2945409jaf.131.2022.06.17.19.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 19:56:25 -0700 (PDT)
Date:   Fri, 17 Jun 2022 19:56:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <62ad3ed172224_24b342084d@john.notmuch>
In-Reply-To: <20220616180609.905015-10-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-10-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH v4 bpf-next 09/10] selftests: xsk: rely on pkts_in_flight
 in wait_for_tx_completion()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> Some of the drivers that implement support for AF_XDP Zero Copy (like
> ice) can have lazy approach for cleaning Tx descriptors. For ZC, when
> descriptor is cleaned, it is placed onto AF_XDP completion queue. This
> means that current implementation of wait_for_tx_completion() in
> xdpxceiver can get onto infinite loop, as some of the descriptors can
> never reach CQ.
> 
> This function can be changed to rely on pkts_in_flight instead.
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---

Sorry I'm going to need more details to follow whats going on here.

In send_pkts() we do the expected thing and send all the pkts and
then call wait_for_tx_completion().

Wait for completion is obvious,

 static void wait_for_tx_completion(struct xsk_socket_info *xsk)               
 {                                                   
        while (xsk->outstanding_tx)                                                      
                complete_pkts(xsk, BATCH_SIZE);
 }  

the 'outstanding_tx' counter appears to be decremented in complete_pkts().
This is done by looking at xdk_ring_cons__peek() makes sense to me until
it shows up here we don't know the pkt has been completely sent and
can release the resources.

Now if you just zero it on exit and call it good how do you know the
resources are safe to clean up? Or that you don't have a real bug
in the driver that isn't correctly releasing the resource.

How are users expected to use a lazy approach to tx descriptor cleaning
in this case e.g. on exit like in this case. It seems we need to
fix the root cause of ice not putting things on the completion queue
or I misunderstood the patch.


>  tools/testing/selftests/bpf/xdpxceiver.c | 3 ++-
>  tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index de4cf0432243..13a3b2ac2399 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -965,7 +965,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
>  
>  static void wait_for_tx_completion(struct xsk_socket_info *xsk)
>  {
> -	while (xsk->outstanding_tx)
> +	while (pkts_in_flight)
>  		complete_pkts(xsk, BATCH_SIZE);
>  }
>  
> @@ -1269,6 +1269,7 @@ static void *worker_testapp_validate_rx(void *arg)
>  		pthread_mutex_unlock(&pacing_mutex);
>  	}
>  
> +	pkts_in_flight = 0;
>  	pthread_exit(NULL);
>  }
