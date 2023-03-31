Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293766D1606
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 05:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCaDcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 23:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjCaDcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 23:32:21 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89113191E5
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:32:11 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q206so12626876pgq.9
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680233530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EpwfiK6OSweJoJ4X70Gvq2mGWAZMiFEn21CRBylaXic=;
        b=EhMwN94kOyyoVi/0Sl386QIHmZOOCqtHJLNnWCcaaiCu2kGVNimw2OEXYb4KjzKWof
         FdGkFw47QzD2XMQ4FC4b6x1bl9IlQkGnKx/d2QUh2IfznmfU/LNuLlCoSF1FtVqzOCHs
         +UEk12JfgJDhLoiQsXrxRIC8lvovl9pcaGohPh3KVpS9IjZ0RAt4Fvao9scyazasjRvd
         wMgKcrF2NVXsGWyQWtoPmM3CZ46/HskzViomJntBZRf9L2ACcR4MGSntH266Pa6/MJmk
         d1MR2k5QsDCajr4js8lHXc0GZHadn9ZBTzZZDADVG8QtES2r3f+dYGVBX5QnCQKiXZxH
         ZKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680233530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpwfiK6OSweJoJ4X70Gvq2mGWAZMiFEn21CRBylaXic=;
        b=5xGRWnuQ6Jad+4l3WYQOXFgSfOC0oRqNHL5KZ4W959h05K9Wle0i8BET37BbHBdapw
         K8MsWqhJFbvDVL0AeGZJY64Z6GvkueacNW03EpfJcjwPyzw7iHAzNtbP3GZUYgmVeI4C
         ZWuZYOlyKJtKGbsDVhgw9o3iwkrj5RBVbpKGysNCceRUrYa3HVBa/rKwhdJJ4jXStA0W
         GcnitxPsM7YDdh6R0W4hO9QddGixbuLBj3mrQ/o4YAurl5Zk2ugQ7ZgjEPB11EaAgQRh
         3E8oqXV0JuTCaOA2Z1GPTodcgA9jYqDmT76+1wB8X53ZCsLf1XmZ33x1Qt8I0L2TmNJP
         jU1Q==
X-Gm-Message-State: AAQBX9cRdmR9xghxckv9AGXwDs2xdkctt8eWqRY5LGN6qZkUIm6E1FfY
        6hlnYI3f6TYJaK5AqSd2Zp8=
X-Google-Smtp-Source: AKy350b6PD6DnstcM9Mow/5ZEgboNm1vDOUst2LezQrwGSsSQ0vLerKoVxiblxtdkSAFrIJiYYJBBQ==
X-Received: by 2002:a62:1811:0:b0:62a:4503:53ba with SMTP id 17-20020a621811000000b0062a450353bamr23351014pfy.26.1680233530377;
        Thu, 30 Mar 2023 20:32:10 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:7821:7c20:eae8:14e5:92b6:47cb])
        by smtp.gmail.com with ESMTPSA id j11-20020aa7800b000000b005895f9657ebsm588838pfi.70.2023.03.30.20.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 20:32:09 -0700 (PDT)
Date:   Fri, 31 Mar 2023 11:32:03 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
Message-ID: <ZCZUMzk5SM9swbDT@Laptop-X1>
References: <20230329031337.3444547-1-liuhangbin@gmail.com>
 <ZCQSf6Sc8A8E9ERN@localhost>
 <ZCUDFyNQoulZRsRQ@Laptop-X1>
 <7144.1680149564@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7144.1680149564@famine>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 09:12:44PM -0700, Jay Vosburgh wrote:
> >> Would it make sense to check if all devices in the bond support
> >> SOF_TIMESTAMPING_TX_SOFTWARE before returning it for the bond?
> >> Applications might expect that a SW TX timestamp will be always
> >> provided if the capability is reported.
> >
> >In my understanding this is a software feature, no need for hardware support.
> >In __sock_tx_timestamp() it will set skb tx_flags when we have
> >SOF_TIMESTAMPING_TX_SOFTWARE flag. Do I understand wrong?
> 
> 	Right, but the network device driver is required to call
> skb_tx_timestamp() in order to record the actual timestamp for the
> software timestamping case.
> 
> 	Do all drivers that may be members of a bond return
> SOF_TIMESTAMPING_TX_SOFTWARE to .get_ts_info and properly call
> skb_tx_timestamp()?  I.e., is this something that needs to be checked,
> or is it safe to assume it's always true?
> 
> 	If I'm reading things correctly, the answer is no, as one
> exception appears to be IPOIB, which doesn't define .get_ts_info that I
> CAN Find, and does not call skb_tx_timestamp() in ipoib_start_xmit().

Oh.. I thought it's a software timestamp and all driver's should support it.
I didn't expect that Infiniband doesn't support it. Based on this, it seems
we can't even assume that all Ethernet drivers will support it, since a
private driver may also not call skb_tx_timestamp() during transmit. Even if
we check the slaves during ioctl call, we can't expect a later-joined slave
to have SW TX timestamp support. It seems that we'll have to drop this feature."

Thanks
Hangbin
