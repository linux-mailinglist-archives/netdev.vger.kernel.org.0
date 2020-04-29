Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87C21BD2F9
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 05:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgD2Dcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 23:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726551AbgD2Dcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 23:32:33 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9BBC03C1AC;
        Tue, 28 Apr 2020 20:32:33 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r4so377346pgg.4;
        Tue, 28 Apr 2020 20:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oHg4Ih2xVy73JUSYzpNHihoFqPKep8Y6MUVusqxfGHo=;
        b=DEzkn1Q2sV8YnzuyZMmp49TnNti9jXTPEoRtXMeZh7nSEiBYone93vuWY71UrPoR21
         DPPV2r+SF2HtVON5l9Sr9ywBMPCo+U5N2Qh3uqO6ufGK4vPsIPlbNE19E3IgAHBmY8fE
         DuBGiaprTw/aBDsbHxv/zmRu+rHWJ0n0Fr60za8AjHQTFLdBDf4bMAegs41LgcCvjCtL
         dLkDTxrS0uiMl99Y2e4u3kr4DxOnnXXYrbF90o/Of6k8Z9qXw6Ch5cXnuHyqAD+HBQeX
         dTniC4FxGvhndzgn1bRWnkguugaeIvQKq1dnUoR6DNK5JGMxSExBGfRJlgFJJuDuFkXi
         7ACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oHg4Ih2xVy73JUSYzpNHihoFqPKep8Y6MUVusqxfGHo=;
        b=WM/PeUI23kDNFX7aeftrVbUGwX2T3BQYx/vZiH2KnyQP88tMM4d4gBfzlH1qNB1yDw
         fO0tSWMQUN2+VcrfmhHKO4UkAwXFaY8CKn2PQCbAwzARV8aik4y/kABWhby9pmw9MLXf
         9MeK5lt+z16NX2GzpgCF9UXJIIWbCq6yDNQe55j8CbG9Y+zONoC+z+iRjyJSkI+w700K
         IlOMGnLUVKMolfVX0wiUhbydqATJL+HMIyMTzIj6pliBNr3qbFJd0/COLh7hXGNiBBhM
         luqQs2dGcG1ZGom7MWKVumba0rNiM6zt9HoYomzXR0iZEZhpOWlPO1QdpjoMF81iKZ/8
         QcMg==
X-Gm-Message-State: AGi0PubVWSvllbsL6kj0Q30qFH9tOpgFY5Z3ewHf9FDGUmxaW9MsAdju
        puMuXRiU9fFY7zVEZaExFc4=
X-Google-Smtp-Source: APiQypJG70HpsOK6hrOP3VAywbncJqho0L31EVeVgjGpNQWCzfcr0gBT3U8gtbDDSqflGvDyeHYSrQ==
X-Received: by 2002:a63:cc01:: with SMTP id x1mr21995994pgf.428.1588131152845;
        Tue, 28 Apr 2020 20:32:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:3700])
        by smtp.gmail.com with ESMTPSA id c12sm9234847pgk.11.2020.04.28.20.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 20:32:32 -0700 (PDT)
Date:   Tue, 28 Apr 2020 20:32:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com
Subject: Re: [PATCH bpf-next] bpf: bpf_{g,s}etsockopt for struct bpf_sock
Message-ID: <20200429033229.hd243khhh6q5mwrd@ast-mbp.dhcp.thefacebook.com>
References: <20200428185719.46815-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428185719.46815-1-sdf@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:57:19AM -0700, Stanislav Fomichev wrote:
> Currently, bpf_getsocktop and bpf_setsockopt helpers operate on the
> 'struct bpf_sock_ops' context in BPF_PROG_TYPE_CGROUP_SOCKOPT program.
> Let's generalize them and make the first argument be 'struct bpf_sock'.
> That way, in the future, we can allow those helpers in more places.
> 
> BPF_PROG_TYPE_CGROUP_SOCKOPT still has the existing helpers that operate
> on 'struct bpf_sock_ops', but we add new bpf_{g,s}etsockopt that work
> on 'struct bpf_sock'. [Alternatively, for BPF_PROG_TYPE_CGROUP_SOCKOPT,
> we can enable them both and teach verifier to pick the right one
> based on the context (bpf_sock_ops vs bpf_sock).]
> 
> As an example, let's allow those 'struct bpf_sock' based helpers to
> be called from the BPF_CGROUP_INET{4,6}_CONNECT hooks. That way
> we can override CC before the connection is made.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Looks good to me and safety checks seem to be correct.
Martin,
could you please help review as well?
