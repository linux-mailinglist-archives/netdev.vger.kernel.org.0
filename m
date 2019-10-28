Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D97FE7BDF
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389135AbfJ1V6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:58:43 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:40408 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbfJ1V6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:58:42 -0400
Received: by mail-il1-f195.google.com with SMTP id d83so9560681ilk.7
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 14:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cuqLlOvwFQybViTG6mctYmzDQi68WgMBcKajjI9VfQA=;
        b=NBioJgkSFQkg9z3SK96hquTNA7F4qJpammx/7r25sHbpdVUZwHEQfDEpf6rEtAzxn4
         5tZBB9+HGKARXJ7FSeoAta8yU5fjfnGiCip0NWOR4YQ6/xTtowiP/sN82XRRl8ctSKtK
         ZRQuSFztUWF+gcfxL4ANC+fqM0J7/y+Ic4h9PKxR4Bg+TSgMTG8XMrySlSp+6nWQ18yy
         6UvL3tc98t3NSTNC+f+8lRKbn9OwS0aaUxRm6e+jtkYXMkAXIDl/wlqxwdbuoWYBoGEV
         U1e+kI6rgvW12NyCT7cKZl96CdOOQY6cHEdQIKjpqdx+XmYY0LUu80lVqpZ1x++oJiOv
         KVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cuqLlOvwFQybViTG6mctYmzDQi68WgMBcKajjI9VfQA=;
        b=Ly0f6JSQ5y/lZ3U+zeYMj0QB/nlIYL9+UvHfpLKTphfJW0rn0Dh8YrcrhKZd4YLs6z
         PaMVMymBoIftc9vlWGx5bvK3zMbYq8tTzo90zX1v5qmb0nkoO2MhHEwrshTVG0jro/fD
         gF3JI0DHpaYr5HzJXgxZwNZn5Y1Oi+BfGM80fQdhPkX4lTjOBY6D7WyLURava4hKbmb2
         3wqiON3x5UdOnKna7gT5K+8I3rZ0DI73gLo38zN9gkQRiRhLrj7O9IZLXfpGQj9jGgmw
         KEASiV4i3Jc/kfYdfVgpXbCT8sYVaAHR4uDiU7js2SPL0OPDLudgBJacsxO86i1/GgMz
         a9Gg==
X-Gm-Message-State: APjAAAX1K04kACC8mhBxC38cH1yfA0Irt+X9E4Po/IeodaGundfqIFEl
        uPi4C0TWCEACl0I7VLZpyyqp4NiTavoe3ejvW0A=
X-Google-Smtp-Source: APXvYqwCCtNC83P4mABWfpNmQAOefuD0wg/T7uv4sQhJv+K4rgI0ZHgCWpqKZta0SaiksG3Gc5KSnuvJGOMeRR3cFC0=
X-Received: by 2002:a92:5d88:: with SMTP id e8mr21987703ilg.95.1572299921396;
 Mon, 28 Oct 2019 14:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com> <20191023182426.13233-3-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20191023182426.13233-3-jeffrey.t.kirsher@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 28 Oct 2019 14:58:30 -0700
Message-ID: <CAKgT0Udd52vy8F_CWWZWuxYxk-ZijWQ9oHaMBVBK-RHqOrTApg@mail.gmail.com>
Subject: Re: [net-next 02/11] i40e: Add ability to display VF stats along with
 PF core stats
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Arkadiusz Grubba <arkadiusz.grubba@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Stefan Assmann <sassmann@redhat.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 2:08 AM Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
>
> From: Arkadiusz Grubba <arkadiusz.grubba@intel.com>
>
> This change introduces the ability to display extended (enhanced)
> statistics for PF interfaces.
>
> The patch introduces new arrays defined for these
> extra stats (in i40e_ethtool.c file) and enhances/extends ethtool ops
> functions intended for dealing with PF stats (i.e.: i40e_get_stats_count(),
> i40e_get_ethtool_stats(), i40e_get_stat_strings() ).
>
> There have also been introduced the new build flag named
> "I40E_PF_EXTRA_STATS_OFF" to exclude from the driver code all code snippets
> associated with these extra stats.
>
> Signed-off-by: Arkadiusz Grubba <arkadiusz.grubba@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

So this patch is bad. It is overwriting the statistics strings for
each VF separately. In addition the code isn't really easy to follow
for the stats update as it seems like it is doing a bunch of extra
work and generating far more noise then it needs to.

>  .../net/ethernet/intel/i40e/i40e_ethtool.c    | 149 ++++++++++++++++++
>  1 file changed, 149 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> index 41e1240acaea..c814c756b4bb 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> @@ -389,6 +389,7 @@ static const struct i40e_stats i40e_gstrings_pfc_stats[] = {
>
>  #define I40E_GLOBAL_STATS_LEN  ARRAY_SIZE(i40e_gstrings_stats)
>
> +/* Length (number) of PF core stats only (i.e. without queues / extra stats): */
>  #define I40E_PF_STATS_LEN      (I40E_GLOBAL_STATS_LEN + \
>                                  I40E_PFC_STATS_LEN + \
>                                  I40E_VEB_STATS_LEN + \
> @@ -397,6 +398,44 @@ static const struct i40e_stats i40e_gstrings_pfc_stats[] = {
>  /* Length of stats for a single queue */
>  #define I40E_QUEUE_STATS_LEN   ARRAY_SIZE(i40e_gstrings_queue_stats)
>
> +#define I40E_STATS_NAME_VFID_EXTRA "vf___."
> +#define I40E_STATS_NAME_VFID_EXTRA_LEN (sizeof(I40E_STATS_NAME_VFID_EXTRA) - 1)
> +

Why bother with this? If you are just going to skip over it in
__i40e_update_vfid_in_stats_strings() anyway why waste the memory on 5
characters per stat? It would simplify your code to just skip it here
since you are inserting it later anyway.

> +static struct i40e_stats i40e_gstrings_eth_stats_extra[] = {

This should be const.

> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "rx_bytes", eth_stats.rx_bytes),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "rx_unicast", eth_stats.rx_unicast),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "rx_multicast", eth_stats.rx_multicast),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "rx_broadcast", eth_stats.rx_broadcast),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "rx_discards", eth_stats.rx_discards),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "rx_unknown_protocol", eth_stats.rx_unknown_protocol),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "tx_bytes", eth_stats.tx_bytes),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "tx_unicast", eth_stats.tx_unicast),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "tx_multicast", eth_stats.tx_multicast),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "tx_broadcast", eth_stats.tx_broadcast),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "tx_discards", eth_stats.tx_discards),
> +       I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
> +                     "tx_errors", eth_stats.tx_errors),
> +};
> +
> +#define I40E_STATS_EXTRA_COUNT 128  /* as for now only I40E_MAX_VF_COUNT */
> +/* Following length value does not include the length values for queues stats */
> +#define I40E_STATS_EXTRA_LEN   ARRAY_SIZE(i40e_gstrings_eth_stats_extra)
> +/* Length (number) of PF extra stats only (i.e. without core stats / queues): */
> +#define I40E_PF_STATS_EXTRA_LEN (I40E_STATS_EXTRA_COUNT * I40E_STATS_EXTRA_LEN)
> +/* Length (number) of enhanced/all PF stats (i.e. core with extra stats): */
> +#define I40E_PF_STATS_ENHANCE_LEN (I40E_PF_STATS_LEN + I40E_PF_STATS_EXTRA_LEN)
> +
>  enum i40e_ethtool_test_id {
>         I40E_ETH_TEST_REG = 0,
>         I40E_ETH_TEST_EEPROM,
> @@ -2190,6 +2229,9 @@ static int i40e_get_stats_count(struct net_device *netdev)
>          */
>         stats_len += I40E_QUEUE_STATS_LEN * 2 * netdev->num_tx_queues;
>
> +       if (vsi == pf->vsi[pf->lan_vsi] && pf->hw.partition_id == 1)
> +               stats_len += I40E_PF_STATS_EXTRA_LEN;
> +
>         return stats_len;
>  }
>

This bit is just wasteful. You already have this check up above in
this function. Why not just add this to I40E_PF_STATS_LEN and be done
with it?

> @@ -2258,6 +2300,10 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
>         struct i40e_vsi *vsi = np->vsi;
>         struct i40e_pf *pf = vsi->back;
>         struct i40e_veb *veb = NULL;
> +       unsigned int vsi_idx;
> +       unsigned int vf_idx;
> +       unsigned int vf_id;
> +       bool is_vf_valid;
>         unsigned int i;
>         bool veb_stats;
>         u64 *p = data;
> @@ -2307,11 +2353,109 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
>                 i40e_add_ethtool_stats(&data, &pfc, i40e_gstrings_pfc_stats);
>         }
>
> +       /* As for now, we only process the SRIOV type VSIs (as extra stats to
> +        * PF core stats) which are correlated with VF LAN VSI (hence below,
> +        * in this for-loop instruction block, only VF's LAN VSIs are currently
> +        * processed).
> +        */
> +       for (vf_id = 0; vf_id < pf->num_alloc_vfs; vf_id++) {
> +               is_vf_valid = true;
> +               for (vf_idx = 0; vf_idx < pf->num_alloc_vfs; vf_idx++)
> +                       if (pf->vf[vf_idx].vf_id == vf_id)
> +                               break;
> +               if (vf_idx >= pf->num_alloc_vfs) {
> +                       dev_info(&pf->pdev->dev,
> +                                "In the PF's array, there is no VF instance with VF_ID identifier %d or it is not set/initialized correctly yet\n",
> +                                vf_id);
> +                       is_vf_valid = false;
> +                       goto check_vf;
> +               }
> +               vsi_idx = pf->vf[vf_idx].lan_vsi_idx;
> +

Okay so this whole block here is just ugly.Why bother with trying to
output this all in-order? We have the stats you need to output as a
giant array, and you should know the base index of that array. So
instead of making this way more complicated and expensive then it
needs to be why not just determine the offset  that you need to output
the stats to based off of the vf_id? It would be much more readable
then the approach you have taken.

> +               vsi = pf->vsi[vsi_idx];
> +               if (!vsi) {
> +                       /* It means empty field in the PF VSI array... */
> +                       dev_info(&pf->pdev->dev,
> +                                "No LAN VSI instance referenced by VF %d or it is not set/initialized correctly yet\n",
> +                                vf_id);
> +                       is_vf_valid = false;
> +                       goto check_vf;
> +               }

This is getting noisy really quick. Do you really need to dump
information if you cannot collect stats on a given VF? There are way
too many messages in here in my opinion.

> +               if (vsi->vf_id != vf_id) {
> +                       dev_info(&pf->pdev->dev,
> +                                "In the PF's array, there is incorrectly set/initialized LAN VSI or reference to it from VF %d is not set/initialized correctly yet\n",
> +                                vf_id);
> +                       is_vf_valid = false;
> +                       goto check_vf;
> +               }

This is more noise. It concerns me that you need all these checks. Is
this something you can actually encounter. If so then maybe these
should be wrapped in some sort of reader/writer lock like what we have
for the netdev queue statistics.

> +               if (vsi->vf_id != pf->vf[vf_idx].vf_id ||
> +                   !i40e_find_vsi_from_id(pf, pf->vf[vsi->vf_id].lan_vsi_id)) {
> +                       /* Disjointed identifiers or broken references VF-VSI */
> +                       dev_warn(&pf->pdev->dev,
> +                                "SRIOV LAN VSI (index %d in PF VSI array) with invalid VF Identifier %d (referenced by VF %d, ordered as %d in VF array)\n",
> +                                vsi_idx, pf->vsi[vsi_idx]->vf_id,
> +                                pf->vf[vf_idx].vf_id, vf_idx);
> +                       is_vf_valid = false;
> +               }

Here we finally get to any productive work.

So as I mentioned before there is a much simpler way to deal with all
of this. What you can do is zero out all of the stats, and then when
you hit this part you just have to access "data + (vf_id *
I40E_STATS_EXTRA_LEN)".

> +check_vf:
> +               if (!is_vf_valid) {
> +                       i40e_add_ethtool_stats(&data, NULL,
> +                                              i40e_gstrings_eth_stats_extra);
> +               } else {
> +                       i40e_update_eth_stats(vsi);
> +                       i40e_add_ethtool_stats(&data, vsi,
> +                                              i40e_gstrings_eth_stats_extra);
> +               }
> +       }
> +       for (; vf_id < I40E_STATS_EXTRA_COUNT; vf_id++)
> +               i40e_add_ethtool_stats(&data, NULL,
> +                                      i40e_gstrings_eth_stats_extra);
> +
>  check_data_pointer:
>         WARN_ONCE(data - p != i40e_get_stats_count(netdev),
>                   "ethtool stats count mismatch!");
>  }
>
> +/**
> + * __i40e_update_vfid_in_stats_strings - print VF num to stats names
> + * @stats_extra: array of stats structs with stats name strings
> + * @strings_num: number of stats name strings in array above (length)
> + * @vf_id: VF number to update stats name strings with
> + *
> + * Helper function to i40e_get_stat_strings() in case of extra stats.
> + **/
> +static inline void
> +__i40e_update_vfid_in_stats_strings(struct i40e_stats stats_extra[],
> +                                   int strings_num, int vf_id)
> +{
> +       int i;
> +
> +       for (i = 0; i < strings_num; i++) {
> +               snprintf(stats_extra[i].stat_string,
> +                        I40E_STATS_NAME_VFID_EXTRA_LEN, "vf%03d", vf_id);
> +               stats_extra[i].stat_string[I40E_STATS_NAME_VFID_EXTRA_LEN -
> +                                                                      1] = '.';
> +       }
> +}
> +

So this is just ugly on so many levels. Actually now that I have
looked into it a bit more why couldn't you simply re-purpose the
__i40e-add_stat_strings() code? You could pre-format your VF strings
and then just have them all get inserted with the correct names and
indexes later.

> +/**
> + * i40e_update_vfid_in_stats - print VF num to stat names
> + * @stats_extra: array of stats structs with stats name strings
> + * @vf_id: VF number to update stats name strings with
> + *
> + * Helper macro to i40e_get_stat_strings() to ease use of
> + * __i40e_update_vfid_in_stats_strings() function due to extra stats.
> + *
> + * Macro to ease the use of __i40e_update_vfid_in_stats_strings by taking
> + * a static constant stats array and passing the ARRAY_SIZE(). This avoids typos
> + * by ensuring that we pass the size associated with the given stats array.
> + *
> + * The parameter @stats_extra is evaluated twice, so parameters with side
> + * effects should be avoided.
> + **/
> +#define i40e_update_vfid_in_stats(stats_extra, vf_id) \
> +__i40e_update_vfid_in_stats_strings(stats_extra, ARRAY_SIZE(stats_extra), vf_id)
> +
>  /**
>   * i40e_get_stat_strings - copy stat strings into supplied buffer
>   * @netdev: the netdev to collect strings for
> @@ -2354,6 +2498,11 @@ static void i40e_get_stat_strings(struct net_device *netdev, u8 *data)
>         for (i = 0; i < I40E_MAX_USER_PRIORITY; i++)
>                 i40e_add_stat_strings(&data, i40e_gstrings_pfc_stats, i);
>
> +       for (i = 0; i < I40E_STATS_EXTRA_COUNT; i++) {
> +               i40e_update_vfid_in_stats(i40e_gstrings_eth_stats_extra, i);
> +               i40e_add_stat_strings(&data, i40e_gstrings_eth_stats_extra);
> +       }
> +

Okay, now this is officially a hard NAK. I hadn't noticed this until
now but you are overwriting the i40e_gstrings_eth_stats_extra? That
should be a const value.

My advice is that this should work like the Tx/Rx rings and PFC stats
do. You cannot be rewriting the strings for every VF. It makes much
more sense to simply use them as an input string and out put the
formatted string into the destination.
