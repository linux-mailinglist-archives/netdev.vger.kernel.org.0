Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA215179122
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 14:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388178AbgCDNRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 08:17:16 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33436 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388091AbgCDNRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 08:17:16 -0500
Received: by mail-qk1-f193.google.com with SMTP id p62so1520400qkb.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 05:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WWNYMYMSOWUh8+QXrbjw+avMih59gstI0YqZlY/DKCg=;
        b=NIurZsN5i5qzat9NbOHaWkErHXSy8Pr7Gw+QiY/YmrvlkReo882zu8mTFOBh0JJ/DW
         tYswuEpmF1dBUVI5scQo5Z2EqPab5EqVgd8WqOvxmiR3lwBfI3bZlMUoj4tPmDLI81nv
         N4mBSV58srMnd8M8udU7ShWByZylR9P8VNoMmzhDYqlshCS6+4zjbsR75mG0kyAIf39d
         b8GJDEkD7ZeIP34TG70gL434PIAooiSGKgJYdLiIDXSlKtD1GiR9ZZQ2O6b7eMd+LU6q
         L+qw3RaPzVmsE2IHxE25et6s5SVN71t4hV83ODkZh1atmv40LTgND5gw3KO8ES9MzQbQ
         662g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WWNYMYMSOWUh8+QXrbjw+avMih59gstI0YqZlY/DKCg=;
        b=CpqdQ4zLCrfagKQgBX2UwEq6WTMLXBxmb0p/peosDefKyaTWzVojnYu6TE8/PHFTMZ
         cfmmfTz8BLz94rAyeNcrs/6ww/gr77AE8UutSg6UA+0w2v/VaEMeGzfHYe2FxvjSOGUi
         mrVv4UeZgnvZuHLvRPbWLcnecNbMb7bkblZ/SUQ/lEUj8aLQRS4IumBDXNQ99/feWUR+
         c2GfNLV6c09WzbB+9sMyFEC5+SGs+9pHfOqQa76edcnwNBlZ682hWbU3G1TRdbsQgBOo
         Th2pT02lffiSqg5SYQ7P3Js2nYxL8AWp/IyHFS+OSR8V/4ULGwsI798drVVxbe9U6ZEB
         QkSQ==
X-Gm-Message-State: ANhLgQ0g+x1ntlo3N+Ei/YMLW8Ta4UtRFtVNKOdB4ptat5jTuTQBKSzv
        9PKwftwzYrUlphgjHNYX2tw=
X-Google-Smtp-Source: ADFU+vuC2M5PtHp42Djia2qtnqhkkt2rhVXlJ2BnzRm/sGnaPa9s3FbX0gBAI86f5ELfv5/S+BtFDg==
X-Received: by 2002:a37:ad18:: with SMTP id f24mr2844185qkm.41.1583327833887;
        Wed, 04 Mar 2020 05:17:13 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.122])
        by smtp.gmail.com with ESMTPSA id s139sm9950332qke.70.2020.03.04.05.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 05:17:13 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 822E6C0E8C; Wed,  4 Mar 2020 10:17:10 -0300 (-03)
Date:   Wed, 4 Mar 2020 10:17:10 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next 1/2] net/sched: act_ct: Fix ipv6 lookup of
 offloaded connections
Message-ID: <20200304131710.GF2546@localhost.localdomain>
References: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
 <1583322579-11558-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583322579-11558-2-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 01:49:38PM +0200, Paul Blakey wrote:
> When checking the protocol number tcf_ct_flow_table_lookup() handles
> the flow as if it's always ipv4, while it can be ipv6.
> 
> Instead, refactor the code to fetch the tcp header, if available,
> in the relevant family (ipv4/ipv6) filler function, and do the
> check on the returned tcp header.
> 
> Fixes: 46475bb20f4b ("net/sched: act_ct: Software offload of established flows")
> Signed-off-by: Paul Blakey <paulb@mellanox.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
