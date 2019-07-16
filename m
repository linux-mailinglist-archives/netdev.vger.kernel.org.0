Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2860C6AC9C
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 18:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfGPQXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 12:23:53 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40675 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfGPQXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 12:23:52 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so10359325pla.7;
        Tue, 16 Jul 2019 09:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wm9jFHTcqMOatUU9rkuQaj5LJJDmwJY4T6TaoWh+l4M=;
        b=VmSAB8JHHWo0lSWU5/J6xTp7vneiItyg+pCu8EWGzWugyoNKS7Zr+0BiXQd4cR4NZ4
         DOBDeRr2P4eS8ivdpHULdaR1H9Lhbn4fkuvyUIZpKUpnauNQ9vjvpj/KA6HXpQ7oeZuf
         WgjiQWXcM9IqUvM+F1DLJ32x7EBc4rDBjTL9xOqkRTDqDxZAEEUMCRR35HiuGFpILCSn
         lpGICND6dawh5A3W9YZXPiJrOZhpgA0q3vHVNSDJ5xREC6ZKV6ItBhC+sjuEAYnn59H2
         ula5MUy0Mhd/r24qewG/+xJSzGvEQIN8QwJqhEm4ExJBlqO+IkbB1St/V3x5rnstu7Uo
         JxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wm9jFHTcqMOatUU9rkuQaj5LJJDmwJY4T6TaoWh+l4M=;
        b=HpS97BAD9ZpN0RRBGVlVcgpYAC8GzNyvmxsWrSL3Lt6dGN91XoqZGm3LpFzmQfooCW
         a18bzhlxsh36TQfoZn6iMi0eOEqkjPYo7L9BbFCmou/HxRsoNxEfa0iMLaM1kNWfPefo
         xlF/Ma03/2PKht1m8B/064wi/qQ5cAkjbFNUkDk2g4oRRGoCSIkzUiZSPDS4VnGdfMdG
         u+7yeyxW6YTR9Tmv5HzjBOzP/9ZkHa+j4WMwfRdEMPmAfc2XGjRRKyK7ZzJKg4tZ0Y96
         5ovZyv8kqPkaYD2Q/57sZVDdU+cqUAriERSWxuCh8nKtxih9bBdFx/ydytk4493wVpI+
         1sFw==
X-Gm-Message-State: APjAAAWahyapFTdrF1OueSjmUAFdSfxzjX/xJ6kqdsflWsPt0XFHpoYN
        0eOsXqgArXa10HpiUDbYFRo=
X-Google-Smtp-Source: APXvYqy36FnkMF7P9HO7H0rac8u0FoOLkJ+NCWZlfqZy3g6/mb5pCE1HCUMSRDq3WAp/nsW/b3qo/g==
X-Received: by 2002:a17:902:6b81:: with SMTP id p1mr34092543plk.91.1563294232115;
        Tue, 16 Jul 2019 09:23:52 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::c7d4])
        by smtp.gmail.com with ESMTPSA id n30sm23976878pgd.87.2019.07.16.09.23.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 09:23:51 -0700 (PDT)
Date:   Tue, 16 Jul 2019 09:23:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, daniel@iogearbox.net, ys114321@gmail.com
Subject: Re: [PATCH bpf v3] selftests/bpf: fix "alu with different scalars 1"
 on s390
Message-ID: <20190716162349.4fsq3pjuigsfwfbo@ast-mbp.dhcp.thefacebook.com>
References: <20190716105353.21704-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716105353.21704-1-iii@linux.ibm.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 12:53:53PM +0200, Ilya Leoshkevich wrote:
> BPF_LDX_MEM is used to load the least significant byte of the retrieved
> test_val.index, however, on big-endian machines it ends up retrieving
> the most significant byte.
> 
> Change the test to load the whole int in order to make it
> endianness-independent.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied, Thanks

