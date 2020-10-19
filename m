Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5636293139
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388045AbgJSW3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388004AbgJSW33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 18:29:29 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BF3C0613CE;
        Mon, 19 Oct 2020 15:29:29 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id t9so977376qtp.9;
        Mon, 19 Oct 2020 15:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f5ZUl9Xi221hdFB7g/FeVPKVF9Q8oGlQ3rF/8wdmx+s=;
        b=PaZOnKdwX3/fLeP+73PAmJedkPONTwWiPBYnw695BNuasD3fkUuM3z6mYbSBO6lbjy
         AzK1OBIw8UyPTf7mMK1hO5VcKfKxXYqr7MneANZ1j8M/GKj44lC79oUQJSKf+/4qC9Xe
         ZS51FgNF26dTHP2G4P9lXyNy6iGJ1K8Nyg58x0pQYRactpKSkEpQ+S8Yz4WdyBCHojWz
         Qyq1kgUPqSrE3MjygMNXVYPHeCW1AiNBUFiFGW8JkckpSNp9Qgzj3obbNyVXLy8MLX9a
         IdjKjB+eUN0ov/Ptbr+8vPOeStC+m6piwNtHd0Dp9dtP91z2+fQf3SGgNUSszdbgayQ/
         0sXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f5ZUl9Xi221hdFB7g/FeVPKVF9Q8oGlQ3rF/8wdmx+s=;
        b=jDZCckMwIzPbAwl/iEF0acxiAThzVQ97vobSV/zo8KmoGilKO0JbNQfI/C7oxArgeP
         fOpD0Lg6+Hhfe/tqCViXDXZbSSmfr5HqXIDo9xsyL1e5w1+W+WLCsGBpiPv8MHdeW1Ys
         JXsalffb4H21zIU4cOrwyuB0hYqpICM0ECue6Vo44bXA06DYqHeZWf7KrAK4ch3rSv9R
         q9cet3fnD0hLNTdJLyolvPBRmYGtDDS+Tiwawl9bDHgWg0Tm2HS3bvIFL2Ovr11liz7z
         vEWEG7gETgzUVSeycfoarriSIcDzkbeOlUr/8FRnn/fLM5IJJAAHZLcN1XFzOWJbaJPE
         3MZg==
X-Gm-Message-State: AOAM532N/NoUismE5mTe5MPoHMI2Lai7BeT8OZN80AIw4Rx6r6dA7mXm
        UVFBs5H2nHErffgWK5dM3Kw=
X-Google-Smtp-Source: ABdhPJzGGFO3WIuofiHYaTilFXCsqNn4DvtdQij1ACxs1CzQP+DwMZ+R7kz3OTJfWeJi3+SY/oIRbw==
X-Received: by 2002:ac8:33e8:: with SMTP id d37mr1680278qtb.310.1603146566980;
        Mon, 19 Oct 2020 15:29:26 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:5091:9c4f:6b95:2ed0:130e])
        by smtp.gmail.com with ESMTPSA id x5sm562725qtk.68.2020.10.19.15.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 15:29:26 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 2EB05C1632; Mon, 19 Oct 2020 19:29:24 -0300 (-03)
Date:   Mon, 19 Oct 2020 19:29:24 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Message-ID: <20201019222924.GE11030@localhost.localdomain>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019221545.GD11030@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ah, please note that net-next is closed.
https://lore.kernel.org/netdev/20201015123116.743005ca%40kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/T/

  Marcelo
