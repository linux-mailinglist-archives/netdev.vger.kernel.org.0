Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6E36CF99B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjC3Dd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3Ddz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:33:55 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643CE5251
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:33:50 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id u20so11617645pfk.12
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680147229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ONQL2NodcD/mO0aOevwoaTzcQIjYQ6uyIb6/nKvMya4=;
        b=BrSj4oXNEPGRx2bMADweT4onJdPu4Ue/m2L5K36RRnzb45QKAMZPb4Fxly7K9h36Oq
         UAoWG5sP2aZ6M9o9CEl6FGxFl4WYgypXinoV5euQlr2w3y0h94mtZ0kX5KM/6cQBk2bi
         aO6JG0K0Jhzqe2fKEtRiU72RVrTwesW/MSnIFcjKY7jmZxYRRIsF2aZM3PheTleGuM2P
         ZDKt5THHKr2DjwHGzpuBSxsuRVI4Cj5cYCwZZ/jeVZa5ZYZCidpJkWevD9rtwQQMPNAA
         WxkIDQ1TSfofv8u8doIqPERk7DuG976sGEYgDLhW/WtcL0Wwdm6g1qSUqTMRTI5h9Z/E
         uDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680147229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONQL2NodcD/mO0aOevwoaTzcQIjYQ6uyIb6/nKvMya4=;
        b=Q7hZcasAqbZtcHWH8gWYMTUhzCqHzcLI/lQIdrjfGc7OLNToWIS0V2VUQA4PMMlBJf
         Tz0+4mfBKLcMtdkN7lhufDce+aIEcpK4ef139h2u1s/nusuSDyUkuD30xyAaOYsjqW6v
         mkAKSIQuW1zqDpNwftnMQ9uHEAQIYZIMHEKtkiR94a8VsyJAtCdIxvnKAUijeYX9H04o
         P5Hy9r92onUkRlw6T21jDdaDMHg5rAwGT4cTHzCE802fkHXkQD+/AVqZX80BdpIDQFhD
         Z/0qm/eqfwzk5PwI/Gs1zgy/7+OHskDFye/KPsYSwkglKNFJOo3uHys2mVtkSUxyaRNX
         dKqQ==
X-Gm-Message-State: AAQBX9fQfsLABn/BM7S4f7y4RF3AQ88KttbN6/yxNeg+I/qc6fM5VxKN
        KQ4Sf6qJHSWvdPGOmr33zg0smiCFvCym/g==
X-Google-Smtp-Source: AKy350Ytcz3fzhp+ZHMuLupCjvQB1wwPJGhBNY89R3uaFzvU8CFNu5TWezm1ytXls5ziK9EV1QtCfQ==
X-Received: by 2002:a62:8443:0:b0:625:c631:8cea with SMTP id k64-20020a628443000000b00625c6318ceamr20880569pfd.15.1680147229435;
        Wed, 29 Mar 2023 20:33:49 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:7821:7c20:eae8:14e5:92b6:47cb])
        by smtp.gmail.com with ESMTPSA id 23-20020aa79217000000b006260645f2a7sm7036215pfo.17.2023.03.29.20.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 20:33:48 -0700 (PDT)
Date:   Thu, 30 Mar 2023 11:33:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
Message-ID: <ZCUDFyNQoulZRsRQ@Laptop-X1>
References: <20230329031337.3444547-1-liuhangbin@gmail.com>
 <ZCQSf6Sc8A8E9ERN@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCQSf6Sc8A8E9ERN@localhost>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 12:27:11PM +0200, Miroslav Lichvar wrote:
> On Wed, Mar 29, 2023 at 11:13:37AM +0800, Hangbin Liu wrote:
> > At present, bonding attempts to obtain the timestamp (ts) information of
> > the active slave. However, this feature is only available for mode 1, 5,
> > and 6. For other modes, bonding doesn't even provide support for software
> > timestamping. To address this issue, let's call ethtool_op_get_ts_info
> > when there is no primary active slave. This will enable the use of software
> > timestamping for the bonding interface.
> 
> Would it make sense to check if all devices in the bond support
> SOF_TIMESTAMPING_TX_SOFTWARE before returning it for the bond?
> Applications might expect that a SW TX timestamp will be always
> provided if the capability is reported.

In my understanding this is a software feature, no need for hardware support.
In __sock_tx_timestamp() it will set skb tx_flags when we have
SOF_TIMESTAMPING_TX_SOFTWARE flag. Do I understand wrong?

Thanks
Hangbin
