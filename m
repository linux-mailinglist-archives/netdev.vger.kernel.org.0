Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5450716EA22
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbgBYPbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:31:16 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44366 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731104AbgBYPbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 10:31:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id y5so7343311pfb.11
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 07:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VzT+Bi9aRcIzHGw33ls7K4ic9gdRd2ue48AE8Ckn9dY=;
        b=SKyrGUWa4UMK4lem3L5ao7gm5EwFg8zzQVwz4lVhuLmNLxggYbFhFp+9qvKw7Ocr4u
         eefBfQiK6VRs3kwbcGZxGik+foeRG2TkAWl28VLy8mOVivZWNOp+nmLcypOw2W3t7wS1
         Pc9+lfTQiqYNKJKNMfkCGUCUckJAoj+10idh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VzT+Bi9aRcIzHGw33ls7K4ic9gdRd2ue48AE8Ckn9dY=;
        b=Iso711L+G17mgNceyXIWHerpkQBaZSmMEjW4bpJ30HkqcSZF7GunQuMC60zBra1+gM
         barO7cxtmMjPodYX6enpuE7Xz0ItiQjeED0LAaOSSkck9ElZWPmhx8XhwwaXvdzePDOp
         sOMrJMISQQjgW+xahcWTFrGmLchkPMETD7i5hpCOUrZ9aInnPkO8KX4vC9m5azY8qVcM
         GEz2hXX7lvTAisEqN44O8gwCVnmoWsp5wy42o1SqW9cOjzOhFL3gUvEBvnBmJ47qkvhn
         /STphkftk+ghN27xrxuTpJ+DBavQWj6Tkb7SvM308T0N74r22WwLnz0UTBM2wf14DPNw
         hjQg==
X-Gm-Message-State: APjAAAVJth3Jt6sAk7LNgWC+cblTVLyzuj2xYQ/3JT1VhweSkSwijDDb
        ldhabMNAZmbmuLAYR8yjMNy1OQ==
X-Google-Smtp-Source: APXvYqz96aCOZJnivHeAhI3DTYBvj8Uq0Ew8+dU6teoDezYVy2LVzhSaLWTs/qKzU1bEWOQ1dEE9Dg==
X-Received: by 2002:a63:8c18:: with SMTP id m24mr60402523pgd.70.1582644675177;
        Tue, 25 Feb 2020 07:31:15 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r62sm17947322pfc.89.2020.02.25.07.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 07:31:14 -0800 (PST)
Date:   Tue, 25 Feb 2020 07:31:13 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        James Morris <jmorris@namei.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 3/8] bpf: lsm: provide attachment points for
 BPF LSM programs
Message-ID: <202002250730.62F9BD642A@keescook>
References: <20200220175250.10795-1-kpsingh@chromium.org>
 <20200220175250.10795-4-kpsingh@chromium.org>
 <0ef26943-9619-3736-4452-fec536a8d169@schaufler-ca.com>
 <202002211946.A23A987@keescook>
 <20200223220833.wdhonzvven7payaw@ast-mbp>
 <c5c67ece-e5c1-9e8f-3a2b-60d8d002c894@schaufler-ca.com>
 <20200224171305.GA21886@chromium.org>
 <00c216e1-bcfd-b7b1-5444-2a2dfa69190b@schaufler-ca.com>
 <202002241136.C4F9F7DFF@keescook>
 <20200225054125.dttrc3fvllzu4mx5@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225054125.dttrc3fvllzu4mx5@ast-mbp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 09:41:27PM -0800, Alexei Starovoitov wrote:
> I'm proposing to rename BPF_PROG_TYPE_LSM into BPF_PROG_TYPE_OVERRIDE_RETURN.

Isn't the type used to decide which validator to use?

-- 
Kees Cook
