Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2118D678
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfHNOqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:46:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45864 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNOqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:46:54 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so8691629plr.12;
        Wed, 14 Aug 2019 07:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=C/HgJ25I8tvmndBMxmt0bsyVpd8eQwU8Ds2rcKgpH0A=;
        b=WmL5SRmgyiAJGWNX7EFDS09vb/9Sw0UJhDeQvMha5yx82xeHQ1DuGA1Mpxvow+8BIr
         ESWZSjU32fPL9qL5WnPqX4CYmDklf1CWa2v+ROYcDeD7jqEySczangrQW9Db+Eqi29cG
         NhrqVX2SiDBSJ09jCyPeiN4wnsJddTVVRqtko+QrGKZ5lAJn1w8yiK261kgyXiL92sSZ
         QDeGxk9y66uO+hYxqkbLjSsWLOcOoClNghJ2/b2kdzJueyLZT4UEPTOUhIpBqYgvX1cO
         hEUxyxlNS41Tbd/0gJh+bmhKXUx/iuCtP9sAjbdj/vFIb0JiCR1Sx7BY94DHAGjZDJB9
         9yAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=C/HgJ25I8tvmndBMxmt0bsyVpd8eQwU8Ds2rcKgpH0A=;
        b=Mzh1qaSDqL7H/ulmkTO85rSpyqqo8pmnLODt2VpW35op/9ozban4V+5u0dTsHEb89j
         a20xN0XO3VnziVW47nHOM9RIC70VC4ed75YAmUn34aSDMLsxWb2pzbvTu1hJcJoxCXZm
         0EMLq1lf0pRz2N6htLaNmPutG5Crs4fE4nZg72eOrzrTdOOx+iLtEHHr078jcZXUxHgX
         5VIXjPwYGby0uPUHmrPQqSjIDsIJS9LNb12e9rjLSTdCKYjoBpH/M1welwQQJxMIAgnM
         eUE1llSWuU9OkdXkd5LJwhfrfcmrg9QjiQKBd/noHGnC84IRRMkrfj5Cj4oMdygXCdJK
         8Mvw==
X-Gm-Message-State: APjAAAWAj+4LSAqUykc3KX1GfNtHzKAYaPRjrByzHNKjWtvPs/kGnyYs
        OnvtZMRPz2fDn5Ku0A6cNKM=
X-Google-Smtp-Source: APXvYqx9YQ3vULbpEAfo+40fOeew9EainU/7et4KrcvMAtFqeVFsUnahNHvaHlQCPCSfHa/6pVZgXQ==
X-Received: by 2002:a17:902:9698:: with SMTP id n24mr2908901plp.14.1565794013396;
        Wed, 14 Aug 2019 07:46:53 -0700 (PDT)
Received: from [172.26.122.72] ([2620:10d:c090:180::6327])
        by smtp.gmail.com with ESMTPSA id l4sm23278pff.50.2019.08.14.07.46.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 07:46:52 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, brouer@redhat.com, maximmi@mellanox.com,
        bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v4 1/8] xsk: replace ndo_xsk_async_xmit with
 ndo_xsk_wakeup
Date:   Wed, 14 Aug 2019 07:46:51 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <B49497F3-8DD7-4C24-B7EE-CBF3488A913C@gmail.com>
In-Reply-To: <1565767643-4908-2-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-2-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:

> This commit replaces ndo_xsk_async_xmit with ndo_xsk_wakeup. This new
> ndo provides the same functionality as before but with the addition of
> a new flags field that is used to specifiy if Rx, Tx or both should be
> woken up. The previous ndo only woke up Tx, as implied by the
> name. The i40e and ixgbe drivers (which are all the supported ones)
> are updated with this new interface.
>
> This new ndo will be used by the new need_wakeup functionality of XDP
> sockets that need to be able to wake up both Rx and Tx driver
> processing.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
