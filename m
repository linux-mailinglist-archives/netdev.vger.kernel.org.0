Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9113518E1
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbfFXQlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:41:45 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36138 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfFXQlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:41:45 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so7220942plt.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gm5sBRa22v+IZDsSpfzTxb4F4fV04kTMGW118ImiSvI=;
        b=VJVRjzpUp59zJFTXonFi0Ga39oxdoKoZcoWQ63TheN3nBIohri3p8Yi8XKb+lC8nIk
         sKd4eJYpw0aKx16TGjnBPBS3zVlrNkVPsAvyyR6A0i/osYoXbkBZS+6yyB3FUOuj7HWL
         cN7xCpK0nujho3ZX+tceDBOo7cXZjiRHs2X330w4GIHY2bMItWmD80j4RsP09P8gpvpm
         PgZvYaEA0J2p1YU54m9Frq/hbMhPZaU1vHTbqGILLfe7OuK+E7iVGkOztwh9CamBBhg0
         6JeougBEkrWcUNT2R3zqijLFeN75RTy/68RM6+0aK3TGffIEqe382fPqqhg5hgHttDuf
         2rUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gm5sBRa22v+IZDsSpfzTxb4F4fV04kTMGW118ImiSvI=;
        b=BTiLsvzk35nT/kyALQ86oym59tI7dI1w80VzIBpbejx8ed1JJGtxcL0fAYmZPEPh13
         LowN3Hmp3ccMWQkZUqCPQV87xVFLIJs5tFlt+kWYJafja/AkqBnLSezf6P5NyMBCwQnY
         boueBx4i+vU7eGZpK56IkraAS3n2EYB8Rg+ibpK+Wdz7uETec2vIHVyOZ68NSTkAV0hh
         RJHz1i39U3/Hx/DDdSYJOJ1JSGFIOmwrqw7Wh3J1V9pYfuPjE7v9pttITexYlT7OqLNO
         Twh6Xg4nnbd5syAoy6O8BGI7I6ze4tFTx/c03o21zwIi+lVWj3u8dVYnzK+P7m/+PIva
         eyqw==
X-Gm-Message-State: APjAAAVgqVyKQgJx52KymOQnT5Mks4kLP49l8VNFo5DBSn857AsKJGlm
        13YWgNCdoT+E0jv4YAcwFxk=
X-Google-Smtp-Source: APXvYqycbKl+WU2Z4fCNKrDPrP1xJPgMx8fbrKlgd0OxgXqJ6yG64tM1nFlcXMZ5XheC+eDJiMZFQg==
X-Received: by 2002:a17:902:1003:: with SMTP id b3mr150966269pla.172.1561394504912;
        Mon, 24 Jun 2019 09:41:44 -0700 (PDT)
Received: from [172.20.181.193] ([2620:10d:c090:180::1:73aa])
        by smtp.gmail.com with ESMTPSA id l68sm25029pjb.8.2019.06.24.09.41.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:41:44 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     netdev@vger.kernel.org,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH bpf-next v5 3/3] devmap: Allow map lookups from eBPF
Date:   Mon, 24 Jun 2019 09:41:43 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <66A081F4-544F-4AA7-9412-D18AE5670F71@gmail.com>
In-Reply-To: <156125626158.5209.14261186257358121509.stgit@alrua-x1>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
 <156125626158.5209.14261186257358121509.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Jun 2019, at 19:17, Toke Høiland-Jørgensen wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
>
> We don't currently allow lookups into a devmap from eBPF, because the map
> lookup returns a pointer directly to the dev->ifindex, which shouldn't be
> modifiable from eBPF.
>
> However, being able to do lookups in devmaps is useful to know (e.g.)
> whether forwarding to a specific interface is enabled. Currently, programs
> work around this by keeping a shadow map of another type which indicates
> whether a map index is valid.
>
> Since we now have a flag to make maps read-only from the eBPF side, we can
> simply lift the lookup restriction if we make sure this flag is always set.
>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
