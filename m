Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A23E5FE48
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfGDVzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:55:44 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36708 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfGDVzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:55:44 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so3613896plt.3
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5ltpvdJcMcB2LWBbGgZ5IQZBNUBSt3TMPtfONO3MHSU=;
        b=Ko4r5n2W5k3OXWCw0Fy4k3GUUc1011Q2k769m2o5bZd3C9g0zAWNNpkvRju/ErrBac
         O7+RI1cP4/rNsawvhW1SF+23f7tXx9WUupd0nhonNYAA227lgluUVbljvE7kdgGEzvhN
         2rqrwKb9KLQjnkRKT3kjCLHO2uPNSNSuLK9OFJZUgF20O7v3/QjMn9Xf6FoSSyYI5k4u
         BKj+Xg5oyoh/oexLunaOJjcFsS6i4JaPsQ2EYmMOlB9GXUNmOafhYuSOlLjA8Vhw2p9d
         mbAridHUZQrGHdHwDmIHP3WOK6ElQzGJT3lZPTaQHz1YDxD+iVVWsHRIiYrKUDwzfo4Q
         AJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5ltpvdJcMcB2LWBbGgZ5IQZBNUBSt3TMPtfONO3MHSU=;
        b=BKB9XffGYaHStmDmiWpSF/6GcCWWwPob0mXuZzo75DiycW/NkIBFa+rBw/2xNdSbl+
         G0p+FmrxhhPIMgtwNTPEft5QhL47dTKwdN+8FNMHyLkyISch9a39MQdLr0NX8PDWtqHP
         5pQ2CikVUGtHVEuGJEhKN/e9NyyT5M13H6WbCtoGDGRHSoBSxEv6rugCoX1CrIzpuUK+
         XsPAiFZJ63kH9R2Lmn4QLiKUlvHNS/GAMonST3/gAsvNYSYZIzhBr07G7EOpruD4JUOB
         M7WxRozGJylfHzs3JosTH8w5HXn2CAEfobsPMlq/vo83h4g2s3Uga3q2NFvG0qRq/BAc
         IX4w==
X-Gm-Message-State: APjAAAXNgtdyPa0YAay4WHIrcOZIO5GmhKvqduW0jyZ8zURN3yDbSskH
        dQ2sPXnXLFk37+LpsfjNCK+46w==
X-Google-Smtp-Source: APXvYqw8On7PTA/qF6QkNdwGRoRkul2SWrM1vDz+0uxLDzdzSrGaUx4JsWbIlCVHkvRKhFPrzFTVQQ==
X-Received: by 2002:a17:902:8203:: with SMTP id x3mr469284pln.304.1562277343627;
        Thu, 04 Jul 2019 14:55:43 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::3])
        by smtp.gmail.com with ESMTPSA id u65sm15839222pjb.1.2019.07.04.14.55.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 14:55:43 -0700 (PDT)
Date:   Thu, 4 Jul 2019 14:55:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next v3 1/4] net/sched: Introduce action ct
Message-ID: <20190704145521.29f67ba4@cakuba.netronome.com>
In-Reply-To: <1562241233-5176-2-git-send-email-paulb@mellanox.com>
References: <1562241233-5176-1-git-send-email-paulb@mellanox.com>
        <1562241233-5176-2-git-send-email-paulb@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Jul 2019 14:53:50 +0300, Paul Blakey wrote:
> +static const struct nla_policy ct_policy[TCA_CT_MAX + 1] = {
> +	[TCA_CT_ACTION] = { .type = NLA_U16 },

Please use strict checking in all new policies.

attr 0 must have .strict_start_type set.
