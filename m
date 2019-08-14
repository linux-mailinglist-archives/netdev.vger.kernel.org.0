Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3ABF8C747
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfHNCWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:22:44 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33347 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbfHNCWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 22:22:43 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so81454943qkc.0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 19:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=z1eNV6kRCzjclc6p+n7qpH0nJ+blIHE4Jms78lo7Re4=;
        b=ou9O1za94vicEYB5evBo3UGV5saKNYRbZSsRVGq6D2EpRS0DwNXfkWc6jEQ2L4tawm
         zQdiL/XTVR+8c/cwmqUM9fxzuUvx02QgWlBoaoyCzFYW/VcX0oIcMuS/b0LnDB6elmqa
         7r3ummaYadPsvZzLthbsNM00rd5eC3dm5to0YTmhC+i/Dlr6ezytarZHo12jyLiSaCry
         42/cNmBTj/q0YKJZZOyRQj6gAA28TEwMa3Ou7CjBvXGGUTIwOyP6tVmZSclpubxU9Qf0
         of2kFiUa78ZzdreMXMRQWX6iIjbgSH6YHnyVFupzNK92LKD1VYMODkhx9yVKK5/ImLqu
         IoHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=z1eNV6kRCzjclc6p+n7qpH0nJ+blIHE4Jms78lo7Re4=;
        b=rcDyyOfneXuI+cqBULy4HJEU1noXCstVOqyNT+1eod9ydqf+Ump6fWWZsTUM804KrQ
         prJ9Sf46CredN2CqspFglMHSIdztkrRQaiwdMe4ctOdJgPeaLM/tjT6ZKwU66Qa+xnpE
         pbdHcJNquery2o40obomk+NWrE+dQzBNQMuBCo+f+TaUZRPI8Bi+va0PKkYQBaG4JmGk
         /VkSnEKd2tmd4pH3k3+Q33K63OY41E4LkEYHGUhgjnskKo6kqT+4MJT/icGviH02mfXw
         MV7ohaW29gxDfrN82Di2dOrheiGoVlt8ZG80OrFsn93nDxRblV54py3Jr+0VJRvP6tTn
         bFpw==
X-Gm-Message-State: APjAAAUtmuA/nUsuUcd11pKLuD318IamJesW/KuMBQ+rUxYTemBWMrs1
        M55JvlrfD8rVevmVe6ZfwELD4zCzpwM=
X-Google-Smtp-Source: APXvYqw0u5+lfp003OXOsEyxTpKYyl1yKl8dMHO04YmDmzxc/hSH6xhiXI5iZa614R2wxXofIM5pNA==
X-Received: by 2002:a05:620a:70f:: with SMTP id 15mr35954437qkc.171.1565749362808;
        Tue, 13 Aug 2019 19:22:42 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f7sm3258038qtj.16.2019.08.13.19.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 19:22:42 -0700 (PDT)
Date:   Tue, 13 Aug 2019 19:22:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem@davemloft.net,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: fix the transport error_count check
Message-ID: <20190813192232.02f49f1f@cakuba.netronome.com>
In-Reply-To: <20190813162734.GA2870@localhost.localdomain>
References: <55b2fe3e5123958ccd7983e0892bc604aa717132.1565614152.git.lucien.xin@gmail.com>
        <20190813162734.GA2870@localhost.localdomain>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 13:27:34 -0300, Marcelo Ricardo Leitner wrote:
> On Mon, Aug 12, 2019 at 08:49:12PM +0800, Xin Long wrote:
> > As the annotation says in sctp_do_8_2_transport_strike():
> > 
> >   "If the transport error count is greater than the pf_retrans
> >    threshold, and less than pathmaxrtx ..."
> > 
> > It should be transport->error_count checked with pathmaxrxt,
> > instead of asoc->pf_retrans.
> > 
> > Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>  
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.

> Dave, please consider this one for stable. Thanks.

Ack.
