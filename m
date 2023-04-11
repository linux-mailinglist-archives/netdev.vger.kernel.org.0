Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8496DE51B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 21:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDKTt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 15:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDKTt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 15:49:28 -0400
Received: from mail-pl1-x664.google.com (mail-pl1-x664.google.com [IPv6:2607:f8b0:4864:20::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F9C19AD
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 12:49:27 -0700 (PDT)
Received: by mail-pl1-x664.google.com with SMTP id kh6so7364074plb.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 12:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681242567;
        h=in-reply-to:content-disposition:message-id:subject:cc:to:from:date
         :dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TU8CBLxfk4eZ05khHfJK/g8I5beufxqOFfd4g0qwq6w=;
        b=vyxR3m/h+0TYvnd7606Pd7XGLMYy5dEyQAQ0gVs0b/3Tnm5ACcfeyvlnjn1AMKfNB8
         Qq/cKbyzxAffMf8Mgn+bfhJHSa2EFryONM0lhJMr1qqLOnuN7aHryGwyfmw3Z5TqY+/j
         VeXlSEbG22KHRAuO+Pd8u9UI8heKG1pZbZRQ1hqKD7bAzHaGDdb8xPgeTeRkWww4I2Yz
         zY7zqHOH4DhfHee7gBt/Q8ouDfSZi+asUmyv4V3MOppqpxxqY4g2UcU6rpAn6brLkUd1
         xggDfCiTu4J77X1Cly6zGk2XCuK/1qwuBCXeDAAOYfNf0cNQVOHHwMwnl9gkgCBy9OB9
         Dxig==
X-Gm-Message-State: AAQBX9fhbYzhy6HwCd80H+70C3jVRNNpJ7MgoLmDPnLCgXzxhW/Zp2n2
        pi5F6VPZ/VZsrfNhT+ZKlFInJB1ai1qTR3HWhencc8bH3XkY
X-Google-Smtp-Source: AKy350ZHeTWXt1Nvzjee/07Ht/lSB9fEZf8ty2/zMvX+jtp8G5t2hSnlKw/KTC90uGYUQrOl7Gq2q1IKqt4T
X-Received: by 2002:a17:902:ecc6:b0:1a0:44e7:59dc with SMTP id a6-20020a170902ecc600b001a044e759dcmr21178642plh.40.1681242566918;
        Tue, 11 Apr 2023 12:49:26 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [54.193.82.35])
        by smtp-relay.gmail.com with ESMTPS id a22-20020a170902b59600b001a19438336fsm324732pls.66.2023.04.11.12.49.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Apr 2023 12:49:26 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.67.91])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 25A98301983F;
        Tue, 11 Apr 2023 12:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1681242566;
        bh=TU8CBLxfk4eZ05khHfJK/g8I5beufxqOFfd4g0qwq6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=vyqtUuebFC+8Bq8S31wE0Vpp6Mvb6uTvb94YnEQ0p+znhVQt2PeuQIn1zbMaiLBKr
         H8jMbyQmq9ulhnqVLjNpOWNaVgmDR6SVWp9jjFAxGUW0kWG0zopdjQtnIQNpHST952
         RzAbZgWKJWKtWnd53qMw88KjDa5T3MpUwGGNFEIoABQy+OajECoFtA+YVVN1NrBaNp
         oTcs9247eG0TxokjtKhUOfWHk5wOXw82B/1HGTCukVP+eMT240NNsNIsnoK/naSLe2
         2IZ3JHe9/govQEhY4W6S+MUwjYIb1jAF28ObWywO/u5+xtKtrGUTBm0/gtSuv5meyv
         /tQdiVFqeIJ5Q==
Received: from kevmitch by chmeee with local (Exim 4.94.2)
        (envelope-from <kevmitch@arista.com>)
        id 1pmJzY-0002o4-Pu; Tue, 11 Apr 2023 12:49:24 -0700
Date:   Tue, 11 Apr 2023 12:49:19 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
To:     aroulin@nvidia.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Subject: Re: neighbour netlink notifications delivered in wrong order
Message-ID: <ZDW5v01wOiVQSsOa@chmeee>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e6d685a-66c3-3443-3b35-d7b0d0753a20@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-fruggeri@arista.com as he is no longer at the company

Has there been any progress in getting this patch or some other fix for this
issue into mainline. It's been working well for us so far in our testing.
