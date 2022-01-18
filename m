Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B6B492F4A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245251AbiARUXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349190AbiARUXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:23:11 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D813C061574;
        Tue, 18 Jan 2022 12:23:11 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l16so356742pjl.4;
        Tue, 18 Jan 2022 12:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zCaLK1P3uLtGJI4jaYORwKjabpkAr77DKoeq6b3kb9Q=;
        b=C7mOGjqbxCoT3r4XS8rwfRfjzFkm4j0iCWXpTkYpJX0AWXl/z2Gpojc6BH/HAvndjE
         VvwqKzSzxywxACQM6XWBRYk5VagXKT4EexDuoYro2hMteZna/1ehtJLkXc/d+PjLJBZb
         HEUghxWzpIGk7vm5jAckNl9mSq0/ftLEw2FnfaJC2v2rHWEwMRa4hI6oMrkhVDhmmq7r
         OOvztDfn55uDiWLKiw7QGf+HKUsnMbgxDfuULWxpuq9/9qZE2EqbnHGR5/jCrSt+SiIb
         tcaDpTF6J6AnQUsHnP/XkQYYTE7sYSiDpSMlzMaW4loDlLnx+4R5Nnhsdm1PU0i5zK9f
         aKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zCaLK1P3uLtGJI4jaYORwKjabpkAr77DKoeq6b3kb9Q=;
        b=uK//Z7tPzTpYWVE5IrHsHUmKrGChiF8MJfvGjAZqvRn95Mbhe0mkPMtg01ty5vvktf
         ghFb+u3H4iyhxzQ2FCimBOej4JvI+8mjiEZeLW8mkul9A/7K8hqDo3niDaCfTGvjsy5X
         JG5ewRlvud0d4qd+1NDWvUtWD33jUOYlSy2WDrK3E2eRy9pl4xAnNbvFHqL61/4z4IEX
         NqJWP7mmz30XhjEPTJoUEZRdI/Sol22z2TjyMi/3DCVUdTXekn9kX899cLdkHmXpJfZj
         LWTn9U12GocnWgy+XrVj6fqdProhtyro5EO6cT32fekzsoNLyQZcOjyAwwSuPlhri5jy
         s5tQ==
X-Gm-Message-State: AOAM5339tob8anIXNGmjH6jlmOWxHwfT7JC7RbrkGs1cbYo6vHM3Y0Ws
        jboVktjBn7p2azOk5P6On+s=
X-Google-Smtp-Source: ABdhPJyP5MbYROOb9ZN2AGl60lE/B5W17ekDSegfrHykkS7UKCRtXvrngzt+SY2OZyDE8FvMlzMtRg==
X-Received: by 2002:a17:902:bcc8:b0:14a:b277:cdb7 with SMTP id o8-20020a170902bcc800b0014ab277cdb7mr13636819pls.28.1642537391007;
        Tue, 18 Jan 2022 12:23:11 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f291])
        by smtp.gmail.com with ESMTPSA id j3sm2890143pjs.1.2022.01.18.12.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 12:23:10 -0800 (PST)
Date:   Tue, 18 Jan 2022 12:23:08 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v22 bpf-next 19/23] bpf: generalise tail call map
 compatibility check
Message-ID: <20220118202308.2imtkkif4sagb22e@ast-mbp.dhcp.thefacebook.com>
References: <cover.1642439548.git.lorenzo@kernel.org>
 <2e702db189683545e088b74f7d95eb396a329f64.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e702db189683545e088b74f7d95eb396a329f64.1642439548.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 06:28:31PM +0100, Lorenzo Bianconi wrote:
>  	seq_printf(m,
> @@ -590,6 +589,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
>  	if (type) {
>  		seq_printf(m, "owner_prog_type:\t%u\n", type);
>  		seq_printf(m, "owner_jited:\t%u\n", jited);
> +		seq_printf(m, "owner_xdp_has_frags:\t%u\n", xdp_has_frags);

Internal flag shouldn't be printed in fdinfo.
In particular it's not correct for non-xdp progs.
