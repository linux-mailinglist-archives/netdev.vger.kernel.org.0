Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3A1526AB8
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 21:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382323AbiEMTqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 15:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383960AbiEMTqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 15:46:05 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549789C2E7
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 12:46:04 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id j12so11382037oie.1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 12:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q4UGC2HPV6JNzv6iBxTN1Li5Zy8X+v5zkyNIlz4i+C0=;
        b=doaj/sLSDhLCvmUKnygedJfA4Anu61HMJYRuPmwG2UmQdz3YLXnJNnBjAPATJ5oCGL
         re6Q4htdc3S1T7UyUu623R0lfm064RWTgJRSE55x0uf5G9kMI11w3GzvHi9nXfS4Sug1
         g9OsIwGNv5qbcThPT6vd8wdZyyV6MlaU2TGphYXBs4F174E6fNL+m627W89QEoQ8wLQA
         dojCa0QO+I6NDcnn8p4nNfS2zG7vlzBFxkC/v3sDd748al+6i7tXhpJQGKqbTC0a98xY
         cPq/9wOsjfq94nGeZrt8hX4gQyLR7h9M9JeDcB0xremLTDFFxO2WWL6EBNW8mW+bWwQC
         kEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q4UGC2HPV6JNzv6iBxTN1Li5Zy8X+v5zkyNIlz4i+C0=;
        b=7SgIDoYGrof2ANEc6MCzaBJWjX9BrH3OwqAnX/FYg/5FmyOk9UdXtaGO9Ubqpt3YBn
         9+Z4B8oLsXWbU0Alx0h+MVDIQ1ZXU7upw8hwWZI22xa2CrQaxzG+6YFK+IDVSGL/M3XW
         rhbcwZv6dZTAcJILgFATBJGWm3CL8yMbBxZGWZ6TcLcWYfcydMYcTX/5xPtPb/i7xdvl
         Rx/QZkrKT0yaO5u18pe6l7jD4ITsxUGppdzBw9TMU3OWo5B7wXJtXwo9ph3SqmWH6gJJ
         fbZyJ5kRUyYa48Eoh1vXib7QjkDEaO07IbOoUCVgYmi3AQhowFxkPvfijr33xSksu7uS
         jVTg==
X-Gm-Message-State: AOAM5326PqE7vHapaVb9+ImIy/dI2mxfbRLBbOun1uZKIdFVFvxS819R
        CXl0eSRWpuR/8HdP/Ngdv8g=
X-Google-Smtp-Source: ABdhPJyKaOnC2cCLF3WxkWJX9yxRZ1uX4fbLftDEVPgPgzj381B+ou22cLAUn2klsAxi3Oj+yELUvg==
X-Received: by 2002:a05:6808:e82:b0:322:4c17:2f61 with SMTP id k2-20020a0568080e8200b003224c172f61mr3043546oil.131.1652471163542;
        Fri, 13 May 2022 12:46:03 -0700 (PDT)
Received: from t14s.localdomain ([168.194.162.84])
        by smtp.gmail.com with ESMTPSA id l14-20020a056830238e00b0060603221264sm1337460ots.52.2022.05.13.12.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 12:46:03 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 158BE268891; Fri, 13 May 2022 16:46:01 -0300 (-03)
Date:   Fri, 13 May 2022 16:46:01 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Subject: Re: [PATCH v2 net-next 02/10] sctp: read sk->sk_bound_dev_if once in
 sctp_rcv()
Message-ID: <Yn61efcRXVLcgDGS@t14s.localdomain>
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
 <20220513185550.844558-3-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513185550.844558-3-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 11:55:42AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> sctp_rcv() reads sk->sk_bound_dev_if twice while the socket
> is not locked. Another cpu could change this field under us.
> 
> Fixes: 0fd9a65a76e8 ("[SCTP] Support SO_BINDTODEVICE socket option on incoming packets.")

2005.. :-)

> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
