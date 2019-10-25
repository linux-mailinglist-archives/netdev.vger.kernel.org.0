Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729EEE53B4
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388608AbfJYSTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:19:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33658 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388583AbfJYSTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:19:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id u23so2068744pgo.0;
        Fri, 25 Oct 2019 11:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7c7GZBUp2JhMxDLA+PDChBp0paUoSxOP0kQ4Ajyxt5U=;
        b=RWGnQwPLHQEpbgj15ThZsGuKf7KXBY18fbT5Y/cl8HgG6Sa+e5iUb72sKl+a+eWJsk
         1Ynqanh/Slb7/SB6jptxpGKibsuU2c1X6qQYcUaacd9DVtvA/tsE6Fus8uX8+XZy4cdx
         e3ZGHNYWzW8kSwF86+JFCOMC9deBXPWjDSCu6W8mb4+xVkkMv52QmJFNdUah9baonaEQ
         gIoO+oiC+kx8DicB+3gBiqkYT1ow4JtjXaUK+31J6hykMRvtYZxNSuSjmQwwPZgZ+Q2a
         pQIdBNaGW8NYxT94NL0OFEKAvKBvCG5dS3zmW6RHgpfEduEodIF9IeFJ2hQx+RCEP7CN
         8/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7c7GZBUp2JhMxDLA+PDChBp0paUoSxOP0kQ4Ajyxt5U=;
        b=mnoey9dcM5bzP15hjyTwhiV7CpnzEPLbfl7154cyXgplTXaXoGOAdAYQVG1+2LVPNR
         23Utg5ZaUfoZyh3UFgQN05ttRWoq+4lG6AxLZGMV0uo4HEs/H6gTY1T7V9GukLEBSBDD
         E1w+7cnIXYzM3qMDMsGb3+MxIb8FBRhRghcWwSSoQH4DdkdkvrstAFOFIgqKsmlYyVKI
         kf5dRX4i132Zfr3+hZWo2+0JwV5jZkErJoldIKDSdy/PHCng/eZvf0zchXHm5SiaKQ1a
         8zky9IAoQ1g/6akMwkulZJtLBfQgUVKDhAEqHNrrCdIwwh+gkrRU69yT2OlNdd87O8/4
         vxcw==
X-Gm-Message-State: APjAAAUVCHlj/VOBZokiTYaJxBPvJVQfGwD0B2ZpEtZy80w5zXk2q8xI
        0ZiXzcx/pNzyBp46DIGz52g=
X-Google-Smtp-Source: APXvYqy2iDC05E4tnY6TdblvQiA92hfV7cgBg/vMgSp9JPuR+6lMisQ5SlT7lEJQmcWz3R48McSu2g==
X-Received: by 2002:aa7:8642:: with SMTP id a2mr3840720pfo.108.1572027549325;
        Fri, 25 Oct 2019 11:19:09 -0700 (PDT)
Received: from [172.20.54.239] ([2620:10d:c090:200::1:4b93])
        by smtp.gmail.com with ESMTPSA id y10sm3098910pfe.148.2019.10.25.11.19.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 11:19:08 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com,
        "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, toke@redhat.com
Subject: Re: [PATCH bpf-next v3 2/2] bpf: implement map_gen_lookup() callback
 for XSKMAP
Date:   Fri, 25 Oct 2019 11:19:08 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <D9400F0D-2C5C-421E-9CC1-3D4975D7A56E@gmail.com>
In-Reply-To: <20191025093219.10290-3-bjorn.topel@gmail.com>
References: <20191025093219.10290-1-bjorn.topel@gmail.com>
 <20191025093219.10290-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25 Oct 2019, at 2:32, Björn Töpel wrote:

> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>
> Inline the xsk_map_lookup_elem() via implementing the map_gen_lookup()
> callback. This results in emitting the bpf instructions in place of
> bpf_map_lookup_elem() helper call and better performance of bpf
> programs.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
