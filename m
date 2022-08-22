Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5DD59C310
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 17:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiHVPlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 11:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiHVPlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 11:41:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775581CFC0;
        Mon, 22 Aug 2022 08:40:59 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f17so4552603pfk.11;
        Mon, 22 Aug 2022 08:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=rk9SRCNftCXw4ksd+nOSPjNTRiAuzJr7RvJiVNql6UM=;
        b=O4vuEFEkJRlTwdN5y1v9qKYbQMZ/LDJmgySuo9UvcuTnO9sANcT7+zck7c+0cmh4Jc
         m57EnWe0Q3dh0oVrD8foo2mxUrRfoDjtV4/uCVGUGn+kUeUWzplzA637uPDSIcYKma0r
         DpTgfMtTAThyyLbyBJuI+7qBLm6yVv6y0Q+iDxVCMeCqjmEFK6yNtMMGCgrEBOKZfbee
         z0XxnQTUubPM1uGa1sCMqfXnoqsQ1afKZF00Dlq/y40LopmAFH+Jmuy0DBB7ratofrzX
         KM/ODuqseNPILKG09uepYRl9cEXhehgXfYItn6pwOHOGOZKxI7np53JEax6LF4xD5hKK
         a+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=rk9SRCNftCXw4ksd+nOSPjNTRiAuzJr7RvJiVNql6UM=;
        b=3hamUounmLgbMK/Wa34kUwEySjp8WJjGJzXnqtTWKf8qLOBLJjRzJQVgwrE2LFYPyR
         w5A7TUFcuIyqWgNyUObeh81GffrqMEoksI5PF4PkrEMjlLqvuDxWJQw6vQp4XJjZm8oh
         zEFST8pLBeNJiatJ483j70bt8wXit16smr6fG8gzxdtsWH9P+p4M+yjwlaOe7/nRrRK/
         MnRjj41awz5b2Qf6qBF/s0EFWU8utj23E+ZlTpx1I38D7Ht0o/SsPf/MILyiILgImVbX
         j30ZYNKnwteiOI72EySa7DR5UhcaUuqFhLkRG97x2q+aHfuKc7afu9RJaxko1UUB9cBg
         Scdw==
X-Gm-Message-State: ACgBeo2TqybBMwFHrdaNnwS0bUrg715BEr/BrpjYTik8h0V/dHq9WDhH
        OpFI8WYr/Q36DbqsK4WNGIAKFXWsvgm5+f3u
X-Google-Smtp-Source: AA6agR5gl+Oek7jTSV2Py3XeGLz3Megkxk4EWM1wUwvswOLUWLHaz+rIRKSN8NH+NaRKi7TziiuRGA==
X-Received: by 2002:a63:81c6:0:b0:42a:3d97:723c with SMTP id t189-20020a6381c6000000b0042a3d97723cmr13682587pgd.9.1661182859027;
        Mon, 22 Aug 2022 08:40:59 -0700 (PDT)
Received: from localhost ([36.112.204.208])
        by smtp.gmail.com with ESMTPSA id w19-20020a656953000000b0040c40b022fbsm7370993pgq.94.2022.08.22.08.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 08:40:58 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     dan.carpenter@oracle.com
Cc:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        khalid.masum.92@gmail.com, kuba@kernel.org,
        linux-afs@lists.infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com, paskripkin@gmail.com,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
Date:   Mon, 22 Aug 2022 23:39:43 +0800
Message-Id: <20220822153944.6204-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822140532.GF2695@kadam>
References: <20220822140532.GF2695@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 at 22:06, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Mon, Aug 22, 2022 at 07:55:27PM +0600, Khalid Masum wrote:
> > >
> > > /*
> > > + * @holding_mutex: An indication whether caller can still holds
> > > + * the call->user_mutex when returned to caller.
> >
> > Maybe we can use mutex_is_locked instead of using the holding_mutex
> > parameter to get whether call->user_mutex is still held.
>
> That doesn't work.  What if there is contention for the lock and someone
> else took it.  Locks under contention are sort of the whole point of
> locking so it's highly likely.
I trid this before, it doesn't work as Dan points out. I think
it seems that mutex_is_locked() only checks whether there is a task
holding the mutex, but do not check whether it is current task holding
mutex. I also tried lockdep_is_held(), lockdep_is_held() seems can detect
call->user_mutex is still held accurately, although this cannot be the patch.
