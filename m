Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBCBE4AA74
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfFRS5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:57:18 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37920 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730142AbfFRS5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:57:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so16707777qtl.5
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rFniBRZB27OiVctzOe8xy2WTstm/tliD8kmZmH0GaS4=;
        b=IsvLLY9osgDaejE7Iko5+MVIhkNcKYhKC1sR6qaFZiNgnHL32Ut55/1j+IYIJ2dT8g
         FAz0KY20czdZNbP5RNDNFUUNOxH4o28/UIzecriLnyxNNHN3I20k3uC24Rs1V+yGJn9C
         XCtoAyCzqNq5Y7wK3mUeajzV/CjQxUN9fw8qMATbDH3q7VtLPyLxmvCjraIG9Wc2j7IX
         GMynm8nmnimT6WbAPoy/8TD7vt6IwI2Mi4MUJF88Ed5y8ubWiARZZulAgp3KVAExvLrg
         n2kNwtxEwn6lrW/fqyRkNieF4So58lC8HjkmdL870Jcf0VSsY/pHK08OI+7sSrOZ2eYU
         liWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rFniBRZB27OiVctzOe8xy2WTstm/tliD8kmZmH0GaS4=;
        b=r9qPX6+Bym0VB1/OOaDkCYNHpussWBWVPie5m4GTzIIa69MEnXDqQfN5BMi78cWxlR
         jXUWr0mUpWMEGi5+6Zed9xqg+Q61V6Babrq5PXz+mLldktGOt762kfPyjR8IsC/5TiE1
         lTui01bmlKYPJ70bNcDEPD1j10VlwcNk3pWe0yeQtohfPZrL1HZAXUadSoUduH2xYCK5
         r0hy/FQvMkw1jk1NTpDCN9368p5WPv+v5jdRnwn0ZOvghvsgPym39S7IVtxyzB0mOfBi
         uJg5aiBrlPglocMkFl4wIctxTYdX2J/3kTQtryZhf9VwNizhevBEVe5iSLtHTMzosNcg
         4ZFA==
X-Gm-Message-State: APjAAAUQ1ZXFpXZlVJbyqe6OOb83wTUmYiN9i3UAGHGDKe0LtBpYqe2L
        xC72ndRH2q9rCXpiAbFZKUqruw==
X-Google-Smtp-Source: APXvYqxqaW7DBU1u15nbVZ25iMiqgkOB3k+m2fKzpPWu6mIQdL0vL9+NXttxIbSy+5CIkBEv3KOxrQ==
X-Received: by 2002:ac8:3971:: with SMTP id t46mr82479411qtb.164.1560884237453;
        Tue, 18 Jun 2019 11:57:17 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d38sm9819334qtb.95.2019.06.18.11.57.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 11:57:17 -0700 (PDT)
Date:   Tue, 18 Jun 2019 11:57:12 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     John Hurley <john.hurley@netronome.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <fw@strlen.de>, <jhs@mojatatu.com>,
        <simon.horman@netronome.com>, <oss-drivers@netronome.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next 1/2] net: sched: refactor reinsert action
Message-ID: <20190618115712.7bb168c2@cakuba.netronome.com>
In-Reply-To: <dbd77b82-5951-8512-bc9d-e47abd400be3@solarflare.com>
References: <1560522831-23952-1-git-send-email-john.hurley@netronome.com>
        <1560522831-23952-2-git-send-email-john.hurley@netronome.com>
        <dbd77b82-5951-8512-bc9d-e47abd400be3@solarflare.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019 19:43:53 +0100, Edward Cree wrote:
> On 14/06/2019 15:33, John Hurley wrote:
> > Instead of
> > returning TC_ACT_REINSERT, change the type to the new TC_ACT_CONSUMED
> > which tells the caller that the packet has been stolen by another proce=
ss
> > and that no consume call is required. =20
> Possibly a dumb question, but why does this need a new CONSUMED rather
> =C2=A0than, say, taking an additional ref and returning TC_ACT_STOLEN?

Is it okay to reinsert a shared skb into the stack?  In particular this
looks a little scary:

int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
		     gfp_t gfp_mask)
{
	int i, osize =3D skb_end_offset(skb);
	int size =3D osize + nhead + ntail;
	long off;
	u8 *data;

	BUG_ON(nhead < 0);

	BUG_ON(skb_shared(skb));
	^^^^^^^^^^^^^^^^^^^^^^^^

Actually looking for Paolo's address to add him to CC I found that he
said at the time:

  With ACT_SHOT caller/upper layer will free the skb, too. We will have
  an use after free (from either the upper layer and the xmit device).
  Similar issues with STOLEN, TRAP, etc.

  In the past, Changli Gao attempted to avoid the clone incrementing the
  skb usage count:

  commit 210d6de78c5d7c785fc532556cea340e517955e1
  Author: Changli Gao <xiaosuo@gmail.com>
  Date:   Thu Jun 24 16:25:12 2010 +0000

      act_mirred: don't clone skb when skb isn't shared

  but some/many device drivers expect an skb usage count of 1, and that
  caused ooops and was revered.

:)
