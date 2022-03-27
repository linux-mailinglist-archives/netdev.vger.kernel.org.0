Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43C64E87FA
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiC0ONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 10:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbiC0ONX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 10:13:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058F3B7E2;
        Sun, 27 Mar 2022 07:11:45 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso16441124pjb.0;
        Sun, 27 Mar 2022 07:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H1at9llyYi2Z1V+fDKTA1p3pK6c4N+0psjZ6neSptW8=;
        b=AY5IKAeG0b/nRO2YNYn5DJ3RJXQRp9cwlerHO9QEu5SuyvqxaRt+Y4kQSu8kPen1gd
         +QTCTl2i+ujx/iIeLw/OkQYnSaHavw+b5b6dP7O64xgXtICA6Vg46KInj7/bCqZrVRUD
         jzvqIGaDg9pbEtgsCdeFLfXUOjJ6hdnYIhpfy/WEXomag9x1WCNUb977D8Im063IcAnx
         WGIz4KJa5ILF5kaVV+mVrXW5xSqv8CE27nLBaU8977U1XXvSvkIdECWDz+0KTCJ35ASh
         7/DAVYcYONfYMU814D2omwXusfd7cF+dhaRkU3qGN51j2NJjh5ifzCiffylS3JyY8ZqG
         zvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H1at9llyYi2Z1V+fDKTA1p3pK6c4N+0psjZ6neSptW8=;
        b=KwVXlS0gJcYoaA+XbWdUtanh3gt6NsXFMT9SM2karzz5Nc+8c10rM6NrIjbLVoLTfO
         PVdB5grTJPr8zE+waVUn+dhdUOhIqD1x9iLWX+TeVHcugjxwb2Ia0WcvCvOur8/zrpt8
         uL0AUJYlNvuHdHzICqcgbyJYB5mOIlDJ+T2tHTCJr0o6ZCFtzDV6UF3t4g4Q9j3hsL5R
         wUHYa28kPg0DBYRfq+88BQga155aI6sYNIaIr4TW+PWMhib6zcO9NjllhKgGRyfWyIth
         z3Px6MlnLySJZ2rrrXkKTzKkfbvihOa2xFUizU9HHuNgSZsQWURr0tfuREvhrYdIEovD
         YunQ==
X-Gm-Message-State: AOAM530gufjorvrFjn2EnhuRUbHZGPjpC12nqIvFuRd8RVIgXf3vk3/4
        U7qwynxEs1T9PO5qQUwFx0SR2nj5+1ouZw==
X-Google-Smtp-Source: ABdhPJypyC0064bZL/sA9jWIsQTyfVX5ppPpMT+/wezYv0VYl3Q21NusGld36NqZRAk/kYtLeyWPjA==
X-Received: by 2002:a17:90a:5ae4:b0:1bf:9c61:6973 with SMTP id n91-20020a17090a5ae400b001bf9c616973mr24300806pji.73.1648390304427;
        Sun, 27 Mar 2022 07:11:44 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id v13-20020a17090a088d00b001c64d30fa8bsm14689431pjc.1.2022.03.27.07.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 07:11:43 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     chunkeey@gmail.com
Cc:     chunkeey@googlemail.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linville@tuxdriver.com,
        netdev@vger.kernel.org, pabeni@redhat.com, stable@vger.kernel.org,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH] carl9170: main: fix an incorrect use of list iterator
Date:   Sun, 27 Mar 2022 22:11:36 +0800
Message-Id: <20220327141136.17059-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <a5689ba5-2a88-2bef-348b-5bec5cbc3b60@gmail.com>
References: <a5689ba5-2a88-2bef-348b-5bec5cbc3b60@gmail.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Mar 2022 14:05:29, Christian Lamparter <chunkeey@gmail.com> wrote:
> Hi,
> 
> On 27/03/2022 09:27, Xiaomeng Tong wrote:
> > The bug is here:
> > 	rcu_assign_pointer(ar->tx_ampdu_iter,
> > 		(struct carl9170_sta_tid *) &ar->tx_ampdu_list);
> 
> yeah, so... I know there's currently a big discussion revolving
> around LISTs due to incoming the GNU89 to GNU11 switch. I'm not
> currently aware that something related to this had updated
> INIT_LIST_HEAD + friends. So, please tell me if there is extra
> information that has to be considered.
> 
> > The 'ar->tx_ampdu_iter' is used as a list iterator variable
> > which point to a structure object containing the list HEAD
> > (&ar->tx_ampdu_list), not as the HEAD itself.
> > 
> > The only use case of 'ar->tx_ampdu_iter' is as a base pos
> > for list_for_each_entry_continue_rcu in carl9170_tx_ampdu().
> > If the iterator variable holds the *wrong* HEAD value here
> > (has not been modified elsewhere before), this will lead to
> > an invalid memory access.
> > 
> > Using list_entry_rcu to get the right list iterator variable
> > and reassign it, to fix this bug.
> > Note: use 'ar->tx_ampdu_list.next' instead of '&ar->tx_ampdu_list'
> > to avoid compiler error.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: fe8ee9ad80b28 ("carl9170: mac80211 glue and command interface")
> > Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> > ---
> >   drivers/net/wireless/ath/carl9170/main.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> > index 49f7ee1c912b..a287937bf666 100644
> > --- a/drivers/net/wireless/ath/carl9170/main.c
> > +++ b/drivers/net/wireless/ath/carl9170/main.c
> > @@ -1756,6 +1756,7 @@ static const struct ieee80211_ops carl9170_ops = {
> >   
> >   void *carl9170_alloc(size_t priv_size)
> >   {
> > +	struct carl9170_sta_tid *tid_info;
> >   	struct ieee80211_hw *hw;
> >   	struct ar9170 *ar;
> >   	struct sk_buff *skb;
> > @@ -1815,8 +1816,9 @@ void *carl9170_alloc(size_t priv_size)
> >   	INIT_DELAYED_WORK(&ar->stat_work, carl9170_stat_work);
> >   	INIT_DELAYED_WORK(&ar->tx_janitor, carl9170_tx_janitor);
> >   	INIT_LIST_HEAD(&ar->tx_ampdu_list);
> > -	rcu_assign_pointer(ar->tx_ampdu_iter,
> > -			   (struct carl9170_sta_tid *) &ar->tx_ampdu_list);
> > +	tid_info = list_entry_rcu(ar->tx_ampdu_list.next,
> > +				struct carl9170_sta_tid, list);
> > +	rcu_assign_pointer(ar->tx_ampdu_iter, tid_info);
> 
> 
> I've tested this. I've added the following pr_info that would
> print the (raw) pointer of both your new method (your patch)
> and the old (current code) one:
> 
>   pr_info("new:%px\n", list_entry_rcu(ar->tx_ampdu_list.next,struct carl9170_sta_tid, list)); // tid_info
>   pr_info("old:%px\n", (struct carl9170_sta_tid *) &ar->tx_ampdu_list);
> 
> and run it on AR9170 USB Stick
> 
> [  216.547932] usb 2-10: SerialNumber: 12345
> [  216.673629] usb 2-10: reset high-speed USB device number 10 using xhci_hcd
> [  216.853488] new:ffff9394268a38e0
> [  216.853496] old:ffff9394268a38e0
> [  216.858174] usb 2-10: driver   API: 1.9.9 2016-02-15 [1-1]
> [  216.858186] usb 2-10: firmware API: 1.9.9 2021-02-05
> 
> phew, what a relieve :). Both the new and old pointers are the same.
> 

I double check it, and this should not be a bug, at least for now.
the 'list' happens to be the first member of struct carl9170_sta_tid,
so both the new and old pointers are the same. However, we should not
depend on the member order of structure or compiler to guarantee the
correctness, in case some day the order is changed by accident. Instead,
we should guarantee it using the correct logic explicitly.

--
Xiaomeng Tong
