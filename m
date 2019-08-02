Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8457E721
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 02:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732077AbfHBAUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 20:20:34 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42905 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfHBAUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 20:20:33 -0400
Received: by mail-qk1-f196.google.com with SMTP id 201so53478898qkm.9
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 17:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YrAx0zX7auo9QDlbkVDwIncGhtx6wpbCngP7FcTQWIE=;
        b=uFJjTGHGaA/2S8Tg0aI9XTPUgW5bMOgxhC4Mo4QBDPRxI4eILwRSICN6t626DW3MQy
         UT5mXBV84unrcIg7Zvq53rJZZYyS6nuWkTyvNme7sW9fQGtGq5TxKoQaMJ08dYZ1tjz0
         vSK+NSQIs8Y0e8zE3Yu0Ohx8X+Xo4mh4jgSC4tqmRBHTOrETIFvACWXyI+Xof/Gufq2H
         H5livpB85Uj/W75oLHm1FyAcjf4MhOKSRuG7+P8KWEv7ioUcHMWBl7BEnR0ZLIq8tB9N
         vPNrSA0f7lGBfKwR7hdvcCgWpLM919DRjG6q6MuU6lIQB0aDu98AGYr14lqVAlGBL1UV
         c8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YrAx0zX7auo9QDlbkVDwIncGhtx6wpbCngP7FcTQWIE=;
        b=Ks7rmc71FBdV/QN8E0imUHLh3VWhP+YUCwWtpLw0ahn2S6+hkZixeA+VQaRINDqROl
         vkfT0yK/vP3h/LAUV9Z3DcOwLQwey17Rvde/XU5DQR/9Kz0+J4Gr46PY/oAS+MDRGYY9
         tbMET0sqchCXmHNwKhmWY4z4oK8CR2TUA25IFYFia3xq+KrN/cxZ0fj7ciP+B5en7Jmu
         0LvbOJnOcravCDnDDb5MP0haCEa+gJEa+ZmdCtddZgiGWg90FT1PqJEtgx9dtwRDZkQb
         +UPE7CZYrwI5GdpCN7Pj3lXOlnfV6ekltg4E+3a4nyY9e3NHCNhm+DpKCOfra/ZFHiq6
         fR2Q==
X-Gm-Message-State: APjAAAV5ATalMDSM9ademAJXlFJOOs580P8ksL86boaoNfwcoqXtDquc
        P0llWZVIL+LnRrjOxq2Icj4i8Q==
X-Google-Smtp-Source: APXvYqwMbYD3LNl4MXicH/fDkdzKCw1hudlErHNhB9gDh523ZTphg4Ka3FPSXvESVk2M2ey+T/YIow==
X-Received: by 2002:ae9:e707:: with SMTP id m7mr89292148qka.50.1564705231787;
        Thu, 01 Aug 2019 17:20:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e8sm30484586qkn.95.2019.08.01.17.20.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 17:20:31 -0700 (PDT)
Date:   Thu, 1 Aug 2019 17:20:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190801172014.314a9d01@cakuba.netronome.com>
In-Reply-To: <20190801112817.24976-1-pablo@netfilter.org>
References: <20190801112817.24976-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Aug 2019 13:28:15 +0200, Pablo Neira Ayuso wrote:
> Please, apply, thank you.

I'm still waiting for a reply. 

Perhaps since Pablo doesn't want to talk to me someone else can explain
to me why we want to seemingly diverge from the software model?
