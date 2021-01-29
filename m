Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D479308EF1
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhA2VCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbhA2VCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 16:02:19 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D80CC061573
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 13:01:39 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id l9so14957888ejx.3
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 13:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJFAI3GtHJamJgXTYBqxYIofa17Rv5jXrfWgZXXVs50=;
        b=C/w8cxZ3W8rEMbLqSauFC7EADdXCaRhlf2c8cyfo0Xp6yj7oEmdg8o6zMj4sTAuWUJ
         WdyJPadxq/EapVuMRZP96TLw8ObTyDpNhcdP05ciGb87Vcg4Veu5Qp0oPYWTU43AFAI7
         4eo8fJqIeoLOBSLwX8iwNj6ayHxq6kNTQzV+lOVz4I7sFDXlwZDaybB7TjUOc573WC3w
         sKu6loNLWz1ZH9csr1AyPHzNunYj6ohpCxqFxBhysqwMeFvn4TvySbeOLIBN58rXiq1u
         v0KzbryR472VeSEymUi9420OWOY6o/2fHyMrt6o6IG39kW15vmJahSSln5f9oWqA/HJZ
         WwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJFAI3GtHJamJgXTYBqxYIofa17Rv5jXrfWgZXXVs50=;
        b=ng3OMCy7vzvmSX4eYn/dk49LcY5RAADLoC3zys4lzcv4F+925jBG32CNU+2Poas7V8
         LO+qDelpQHW2wnlEDABFImb4k3MOsvc38sEwxKEJicVeCh+GzNWpiCY9v4U6SixNslWg
         BzdDQCxSE8yUkfE0sBxUToLxZ2RD07NcQvgZQYJl9vnkFyBKdbtK+/MJPYDdyUomE7Mb
         aAmEzWWCKfptNczPrGakb+AVMk76lb7JfNQYt3YDTOKztzwCLow6AtGKss1OltUgSPi4
         AU92kcY5arjeUG567Mu1AsL42ifETqhum6kK+edZjQs3vZJjSiPhpnGAkmMs9nTGpVzE
         4j+Q==
X-Gm-Message-State: AOAM530tWQjaz4wZhn66ZoLsNytAdFov9FbKXSllqEiiONeOed1cVEm7
        75vL4NlppMTt/G4cPax/UuL7e+I3LBMBaD6iMGo=
X-Google-Smtp-Source: ABdhPJzLuIUR1oXNnCcZJzL/0ujyA6IkKhj8niShDAd5H3Ndz6eNjZKlSjRFVRSFYgykUqbiUM1A9ecLpFG+8LUQ6Bo=
X-Received: by 2002:a17:906:3b16:: with SMTP id g22mr6303624ejf.504.1611954097904;
 Fri, 29 Jan 2021 13:01:37 -0800 (PST)
MIME-Version: 1.0
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com> <20210129004332.3004826-3-anthony.l.nguyen@intel.com>
In-Reply-To: <20210129004332.3004826-3-anthony.l.nguyen@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Jan 2021 16:01:01 -0500
Message-ID: <CAF=yD-LVEWjcezKidh-JUcuON-L8GWvs34EeMNRrQK1tn0YD8w@mail.gmail.com>
Subject: Re: [PATCH net-next 02/15] ice: cache NVM module bank information
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com, Tony Brelinski <tonyx.brelinski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 7:46 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> From: Jacob Keller <jacob.e.keller@intel.com>
>
> The ice flash contains two copies of each of the NVM, Option ROM, and
> Netlist modules. Each bank has a pointer word and a size word. In order
> to correctly read from the active flash bank, the driver must calculate
> the offset manually.
>
> During NVM initialization, read the Shadow RAM control word and
> determine which bank is active for each NVM module. Additionally, cache
> the size and pointer values for use in calculating the correct offset.
>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_nvm.c  | 151 ++++++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_type.h |  37 ++++++
>  2 files changed, 188 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
> index b0f0b4fc266b..308344045397 100644
> --- a/drivers/net/ethernet/intel/ice/ice_nvm.c
> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
> @@ -603,6 +603,151 @@ static enum ice_status ice_discover_flash_size(struct ice_hw *hw)
>         return status;
>  }
>
> +/**
> + * ice_read_sr_pointer - Read the value of a Shadow RAM pointer word
> + * @hw: pointer to the HW structure
> + * @offset: the word offset of the Shadow RAM word to read
> + * @pointer: pointer value read from Shadow RAM
> + *
> + * Read the given Shadow RAM word, and convert it to a pointer value specified
> + * in bytes. This function assumes the specified offset is a valid pointer
> + * word.
> + *
> + * Each pointer word specifies whether it is stored in word size or 4KB
> + * sector size by using the highest bit. The reported pointer value will be in
> + * bytes, intended for flat NVM reads.
> + */
> +static enum ice_status
> +ice_read_sr_pointer(struct ice_hw *hw, u16 offset, u32 *pointer)
> +{
> +       enum ice_status status;
> +       u16 value;
> +
> +       status = ice_read_sr_word(hw, offset, &value);
> +       if (status)
> +               return status;
> +
> +       /* Determine if the pointer is in 4KB or word units */
> +       if (value & ICE_SR_NVM_PTR_4KB_UNITS)
> +               *pointer = (value & ~ICE_SR_NVM_PTR_4KB_UNITS) * 4 * 1024;
> +       else
> +               *pointer = value * 2;

Should this be << 2, for 4B words?
